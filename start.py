import os
import subprocess

# Caminhos dos scripts/binaries
install_script = "./install.sh"
proot_binary = "./libraries/proot"
proot_arm64_binary = "./libraries/prootarm64"
startup_script = "./start.sh"  # ajuste conforme seu script real

# Dar permissão de execução
os.chmod(install_script, 0o755)
os.chmod(proot_binary, 0o755)
os.chmod(proot_arm64_binary, 0o755)

# Configurar variável de ambiente
env = os.environ.copy()
env["STARTUPSCRIPT"] = startup_script

print("Permissões alteradas, iniciando o install.sh...")

# Executar o install.sh em tempo real
process = subprocess.Popen(
    ["bash", install_script],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    env=env,
    text=True
)

# Mostrar saída em tempo real
for line in process.stdout:
    print(line, end="")

process.wait()
print(f"install.sh finalizado com código: {process.returncode}")
