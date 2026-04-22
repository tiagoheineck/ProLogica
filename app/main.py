from __future__ import annotations

import subprocess
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field

BASE_DIR = Path(__file__).resolve().parents[1]
PROLOG_FILE = BASE_DIR / "prolog" / "diagnostico.pl"
PROLOG_COLONIZACAO_FILE = BASE_DIR / "prolog" / "quiz_colonizacao.pl"

app = FastAPI(title="Quiz de Diagnostico (Educacional)")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount("/static", StaticFiles(directory=BASE_DIR / "app" / "static"), name="static")


class DiagnosticoRequest(BaseModel):
    sintomas: list[str] = Field(default_factory=list)


class ResultadoDiagnostico(BaseModel):
    doenca: str
    confianca: int
    sintomas_correspondentes: int
    total_sintomas_doenca: int
    sintomas_que_bateram: list[str]


class QuizColonizacaoRequest(BaseModel):
    pistas: list[str] = Field(default_factory=list)


class ResultadoColonizacao(BaseModel):
    fase: str
    confianca: int
    pistas_correspondentes: int
    total_pistas_fase: int
    pistas_que_bateram: list[str]


@app.get("/")
def index() -> FileResponse:
    return FileResponse(BASE_DIR / "app" / "static" / "index.html")


@app.get("/colonizacao")
def colonizacao_page() -> FileResponse:
    return FileResponse(BASE_DIR / "app" / "static" / "colonizacao.html")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/api/diagnosticar")
def diagnosticar(payload: DiagnosticoRequest) -> dict[str, object]:
    sintomas_limpos = [s.strip().lower() for s in payload.sintomas if s.strip()]
    sintomas_csv = ",".join(sintomas_limpos)

    if not sintomas_csv:
        return {
            "aviso": "Selecione pelo menos um sintoma.",
            "resultados": [],
            "educacional": True,
        }

    goal = f"executar_csv('{sintomas_csv}')"
    command = [
        "swipl",
        "-q",
        "-s",
        str(PROLOG_FILE),
        "-g",
        goal,
        "-t",
        "halt",
    ]

    try:
        process = subprocess.run(
            command,
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError as exc:
        return {
            "erro": "Nao foi possivel encontrar o comando 'swipl'. Instale o SWI-Prolog.",
            "detalhes": str(exc),
        }
    except subprocess.CalledProcessError as exc:
        return {
            "erro": "Falha ao consultar a base Prolog.",
            "detalhes": exc.stderr.strip() or exc.stdout.strip(),
        }

    resultados: list[ResultadoDiagnostico] = []

    for linha in process.stdout.splitlines():
        partes = linha.split("|")
        if len(partes) != 5:
            continue

        nome, match, total, confianca, sintomas_match_csv = partes
        sintomas_match = [s for s in sintomas_match_csv.split(",") if s]

        resultados.append(
            ResultadoDiagnostico(
                doenca=nome,
                confianca=int(confianca),
                sintomas_correspondentes=int(match),
                total_sintomas_doenca=int(total),
                sintomas_que_bateram=sintomas_match,
            )
        )

    return {
        "educacional": True,
        "disclaimer": "Resultado apenas educativo. Nao substitui avaliacao medica.",
        "sintomas_recebidos": sintomas_limpos,
        "resultados": [r.model_dump() for r in resultados],
    }


@app.post("/api/quiz-colonizacao")
def quiz_colonizacao(payload: QuizColonizacaoRequest) -> dict[str, object]:
    pistas_limpas = [p.strip().lower() for p in payload.pistas if p.strip()]
    pistas_csv = ",".join(pistas_limpas)

    if not pistas_csv:
        return {
            "aviso": "Selecione pelo menos uma pista historica.",
            "resultados": [],
            "educacional": True,
        }

    goal = f"executar_quiz_csv('{pistas_csv}')"
    command = [
        "swipl",
        "-q",
        "-s",
        str(PROLOG_COLONIZACAO_FILE),
        "-g",
        goal,
        "-t",
        "halt",
    ]

    try:
        process = subprocess.run(
            command,
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError as exc:
        return {
            "erro": "Nao foi possivel encontrar o comando 'swipl'. Instale o SWI-Prolog.",
            "detalhes": str(exc),
        }
    except subprocess.CalledProcessError as exc:
        return {
            "erro": "Falha ao consultar a base Prolog do quiz de colonizacao.",
            "detalhes": exc.stderr.strip() or exc.stdout.strip(),
        }

    resultados: list[ResultadoColonizacao] = []

    for linha in process.stdout.splitlines():
        partes = linha.split("|")
        if len(partes) != 5:
            continue

        fase, match, total, confianca, pistas_match_csv = partes
        pistas_match = [p for p in pistas_match_csv.split(",") if p]

        resultados.append(
            ResultadoColonizacao(
                fase=fase,
                confianca=int(confianca),
                pistas_correspondentes=int(match),
                total_pistas_fase=int(total),
                pistas_que_bateram=pistas_match,
            )
        )

    return {
        "educacional": True,
        "disclaimer": "Resultado apenas educativo para revisao historica.",
        "pistas_recebidas": pistas_limpas,
        "resultados": [r.model_dump() for r in resultados],
    }
