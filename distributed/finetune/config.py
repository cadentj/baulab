from dataclasses import dataclass

@dataclass
class Config:

    backend: str = "nccl"
