import { spawn } from "child_process";
import { chmodSync } from "fs";

// Caminhos dos scripts/binaries
const installScript = "./install.sh";
const prootBinary = "./libraries/proot";
const prootArm64Binary = "./libraries/prootarm64";

// Dar permissão de execução
chmodSync(installScript, 0o755);
chmodSync(prootBinary, 0o755);
chmodSync(prootArm64Binary, 0o755);

console.log("Permissões alteradas, iniciando o install.sh...");

// Executar o install.sh em tempo real
const child = spawn("bash", [installScript], {
  stdio: "inherit" // exibe stdout e stderr em tempo real
});

child.on("exit", (code) => {
  console.log(`install.sh finalizado com código: ${code}`);
});
