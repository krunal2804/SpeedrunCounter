# 🚩 Challenge #0: 🎟 Simple Counter Example

🎫 Create a simple Counter:

👷‍♀️ You'll compile and deploy your first smart contracts. Then, you'll use a template React app full of important components and hooks. Finally, you'll deploy a Counter contract written in RUST to a public network to share with friends!  🚀

🌟 The final deliverable is an app that lets users interact with the counter contract. Deploy your contracts to a testnet, then build and upload your app to a public web server.

## Checkpoint 0: 📦 Prerequisites 📚

Before starting, ensure you have the following installed:

- [Node.js (>= v18.17)](https://nodejs.org/en/download/)
- [Yarn](https://classic.yarnpkg.com/en/docs/install/)
- [Git](https://git-scm.com/downloads)
- WSL (for Windows users)
- [Rust](https://rustup.rs/) (including `rustc`, `rustup`, and `cargo`) - Install with:
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source ~/.bashrc  # or restart your terminal
  ```
- `cargo-stylus` - Install with:
  ```bash
  cargo install cargo-stylus
  ```
- [Docker](https://docs.docker.com/get-docker/)
- Curl

### 🔧 Version Requirements

Ensure your tools match the following versions for compatibility:

```bash
# Check your versions
cargo stylus --version    # Should be: stylus 0.5.12
cargo --version          # Should be: cargo 1.78.0-nightly (ccc84ccec 2024-02-07)
rustup --version         # Should be: rustup 1.27.1 (54dd3d00f 2024-04-24)
rustc --version          # Should be: rustc 1.78.0-nightly (d44e3b95c 2024-02-09)
```

If your versions don't match, update them:

```bash
# Update Rust toolchain
rustup update nightly
rustup default nightly

# Install/update cargo-stylus
cargo install cargo-stylus
```

### 🚩 Challenge Setup Instructions

#### For Ubuntu/Mac Users:
1. Open your terminal.
2. Clone the repository:
   ```bash
   git clone -b counter https://github.com/abhi152003/speedrun_stylus.git speedrun_stylus_counter
   cd speedrun_stylus_counter
   yarn install
   ```

3. Start the local devnode in Docker:
   ```bash
   cd packages/stylus-demo
   bash run-dev-node.sh
   ```

4. In a second terminal window, start your frontend:
   ```bash
   cd speedrun_stylus_counter/packages/nextjs
   yarn run dev
   ```

5. Open [http://localhost:3000](http://localhost:3000) to see the app.

#### For Windows Users (Using WSL):
1. Open your WSL terminal.
2. Ensure you have set your Git username and email globally:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

3. Clone the repository:
   ```bash
   git clone -b counter https://github.com/abhi152003/speedrun_stylus.git
   cd speedrun_stylus
   yarn install
   ```

4. Start the local devnode in Docker:
   ```bash
   cd packages/stylus-demo
   bash run-dev-node.sh
   ```

5. **Copy the contract address** from the bash terminal output. You will need to paste this address into the `contractAddress` variable in the `DebugContract` component.

6. In a second WSL terminal window, start your frontend:
   ```bash
   cd speedrun_stylus/packages/nextjs
   yarn run dev
   ```

7. Open [http://localhost:3000](http://localhost:3000) to see the app.

### 🛠️ Troubleshooting Common Issues

#### 1. `stylus` Not Recognized
If you encounter an error stating that `stylus` is not recognized as an external or internal command, run the following command in your terminal:
```bash
sudo apt-get update && sudo apt-get install -y pkg-config libssl-dev
```
After that, check if `stylus` is installed by running:
```bash
cargo stylus --version
```
If the version is displayed, `stylus` has been successfully installed and the path is correctly set.

#### 2. ABI Not Generated
If you face issues with the ABI not being generated, you can try one of the following solutions:
- **Restart Docker Node**: Pause and restart the Docker node and the local setup of the project. You can do this by deleting all ongoing running containers and then restarting the local terminal using:
  ```bash
  yarn run dev
  ```
- **Modify the Script**: In the `run-dev-node.sh` script, replace the line:
  ```bash
  cargo stylus export-abi
  ```
  with:
  ```bash
  cargo run --manifest-path=Cargo.toml --features export-abi
  ```
- **Access Denied Issue**: If you encounter an access denied permission error during ABI generation, run the following command and then execute the script again:
  ```bash
  sudo chown -R $USER:$USER target
  ```

#### 3. 🚨 Fixing Line Endings and Running Shell Scripts in WSL

> ⚠️ This guide provides step-by-step instructions to resolve the Command not found error caused by CRLF line endings in shell scripts when running in a WSL environment.

Shell scripts created in Windows often have `CRLF` line endings, which cause issues in Unix-like environments such as WSL. To fix this:

**Using `dos2unix`:**
1. Install `dos2unix` (if not already installed):
   ```bash
   sudo apt install dos2unix
   ```

2. Convert the script's line endings:
   ```bash
   dos2unix run-dev-node.sh
   ```

3. Make the Script Executable:
   ```bash
   chmod +x run-dev-node.sh
   ```

4. Run the Script in WSL:
   ```bash
   bash run-dev-node.sh
   ```

---

## 💫 Checkpoint 1:  Frontend Magic

> ⛽ You'll be redirected to the below page after you complete checkpoint 0

![image](https://github.com/user-attachments/assets/e4b8dc4a-f304-43ef-8817-ae6d028beea4)

> Then you have to click on the debug contracts to start interacting with your contract. Click on "Debug Contracts" from the Navbar or from the Debug Contracts Div placed in the middle of the screen

![image](https://github.com/user-attachments/assets/11197d34-bb2a-4ab7-8f06-3ff2dfabb67a)

The interface allows you to:

1. Set any number
2. Add numbers
3. Increment count
4. Perform multiplications
5. Track all transactions in the Block Explorer

> After that, you can easily view all of your transactions from the Block Explorer Tab

![image](https://github.com/user-attachments/assets/48ab1e39-7560-4441-b7dc-2acbdf8cedfe)

💼 Take a quick look at your deploy script `run-dev-node.sh` in `speedrun-rust/packages/stylus-demo/run-dev-node.sh`.

📝 If you want to edit the frontend, navigate to `speedrun-rust/packages/nextjs/app` and open the specific page you want to modify. For instance: `/debug/page.tsx`. For guidance on [routing](https://nextjs.org/docs/app/building-your-application/routing/defining-routes) and configuring [pages/layouts](https://nextjs.org/docs/app/building-your-application/routing/pages-and-layouts) checkout the Next.js documentation.

---

## Checkpoint 2: 💾 Deploy your contract! 🛰

🛰  You don't need to provide any specifications to deploy your contract because contracts are automatically deployed from the `run-dev-node.sh`

> You can check that below :

![image](https://github.com/user-attachments/assets/d84c4d6a-be20-426b-9c68-2c021caefb29)

The above command will automatically deploy the contract functions written inside `speedrun_stylus/packages/stylus-demo/src/lib.rs`

> This local account will deploy your contracts, allowing you to avoid entering a personal private key because the deployment happens using the pre-funded account's private key.

## Checkpoint 3: 🚢 Ship your frontend! 🚁

> We are deploying all the RUST contracts at the `localhost:8547` endpoint where the nitro devnode is spinning up in Docker. You can check the network where your contract has been deployed in the frontend (http://localhost:3000):

![image](https://github.com/user-attachments/assets/bb82e696-97b9-453e-a7c7-19ebb7bd607f)

🚀 Deploy your NextJS App

```shell
yarn vercel
```

> Follow the steps to deploy to Vercel. Once you log in (email, github, etc), the default options should work. It'll give you a public URL.

> If you want to redeploy to the same production URL you can run `yarn vercel --prod`. If you omit the `--prod` flag it will deploy it to a preview/test URL.

⚠️ Run the automated testing function to make sure your app passes

```shell
yarn test
```

---

## Checkpoint 4: 📜 Contract Verification

You can verify your smart contract by running:

```bash
cargo stylus verify -e http://127.0.0.1:8547 --deployment-tx "$deployment_tx"
# here deployment_tx can be received through the docker desktop's terminal when you have deployed your contract using the below command:

cargo stylus deploy -e http://127.0.0.1:8547 --private-key "$your_private_key"
# here you can use pre-funded account's private-key as well
```

> It is okay if it says your contract is already verified. 

---

> 🏃 Head to your next challenge [here](https://www.speedrunstylus.com/challenge/simple-nft-example).