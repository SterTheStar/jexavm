import { spawn } from "child_process";
import { chmodSync } from "fs";

// Caminhos dos scripts
const installScript = "./install.sh";
const prootBinary = "./libraries/proot";
const startupScript = "./start.sh"; // ajuste conforme seu script real

// Dar permissão de execução
chmodSync(installScript, 0o755);
chmodSync(prootBinary, 0o755);

console.log("Permissões alteradas, iniciando o install.sh...");

// Executar o install.sh em tempo real
const child = spawn("bash", [installScript], {
  env: { ...process.env, STARTUPSCRIPT: startupScript },
  stdio: "inherit" // exibe stdout e stderr em tempo real
});

child.on("exit", (code) => {
  console.log(`install.sh finalizado com código: ${code}`);
});
