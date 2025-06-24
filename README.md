# 🚩 Challenge #0: 🎟 Simple Counter Example

🎫 Create a simple Counter:

👷‍♀️ You'll compile and deploy your first smart contracts. Then, you'll use a template React app full of important components and hooks. Finally, you'll deploy a Counter contract written in RUST to a public network to share with friends! 🚀

🌟 The final deliverable is an app that lets users interact with the counter contract. Deploy your contracts to a testnet, then build and upload your app to a public web server.

## Checkpoint 0: 📦 Prerequisites 📚

Before starting, ensure you have the following installed:

- [Node.js (>= v18.17)](https://nodejs.org/en/download/)
- [Yarn](https://classic.yarnpkg.com/en/docs/install/)
- [Git](https://git-scm.com/downloads)
- [WSL (for Windows users)](https://www.geeksforgeeks.org/how-to-install-wsl2-windows-subsystem-for-linux-2-on-windows-10/)
- [Docker](https://docs.docker.com/get-docker/)
- [Curl](https://gcore.com/learning/how-to-install-curl-on-ubuntu)
- [Rust](https://rustup.rs/) (including `rustc`, `rustup`, and `cargo`) - Install with (⚠️ **Must use WSL terminal to run these commands**):

  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  ```

  ```bash
  source ~/.bashrc  # or restart your terminal
  ```

- cargo-stylus  
  -> Install cargo-stylus with the below command:

  ```bash
  cargo install cargo-stylus
  ```

    > ⚠️ **Note for Ubuntu users**: If you face issues related to pkg-config while trying to install cargo-stylus, run these commands:
  ```bash
  sudo apt update
  sudo apt install pkg-config
  sudo apt install libssl-dev
  sudo apt install build-essential
  ```


- [Foundry](https://getfoundry.sh/introduction/installation/) - Required for smart contract development

### Foundry Installation Steps:

#### 1. Open your WSL terminal.

#### 2. Install Foundry using the official install script:
```bash
curl -L https://foundry.paradigm.xyz | bash
```

#### 3. Add Foundry to your shell profile

After installation, you'll see instructions to add Foundry to your shell profile (like .bashrc or .zshrc). Usually, you can do:

```bash
export PATH="$HOME/.foundry/bin:$PATH"
```

Add the above line to your ~/.bashrc or ~/.zshrc file, then reload your shell:

```bash
source ~/.bashrc
```

```bash
source ~/.zshrc
```

#### 4. Install Foundry binaries

```bash
foundryup
```

---

### 🔧 Version Requirements

Ensure your tools are ready to use:

#### Check your versions - ⚠️ **Must use WSL terminal to run these commands**

```bash
cargo stylus --version
```

```bash
cargo --version
```

```bash
rustup --version
```

```bash
rustc --version
```

```bash
curl --version
```

```bash
cast --version
```

```bash
forge --version
```


### 🚩 Challenge Setup Instructions

#### For Ubuntu/Mac Users:

1. Open your terminal.
2. Clone the repository:

   ```bash
   git clone -b counter https://github.com/abhi152003/speedrun_stylus.git speedrun_stylus_counter
   ```

   ```bash
   cd speedrun_stylus_counter
   ```

   ```bash
   yarn install
   ```

3. Start the local devnode in Docker:

   ```bash
   cd packages/stylus-demo
   ```

   ```bash
   bash run-dev-node.sh
   ```

4. In a second terminal window, start your frontend:

   ```bash
   cd speedrun_stylus_counter/packages/nextjs
   ```

   ```bash
   yarn run dev
   ```

5. Open [http://localhost:3000](http://localhost:3000) to see the app.

#### For Windows Users (Using WSL):

1. Open your WSL terminal.
2. Ensure you have set your Git username and email globally:

   ```bash
   git config --global user.name "Your Name"
   ```

   ```bash
   git config --global user.email "your.email@example.com"
   ```

3. Clone the repository:

   ```bash
   git clone -b counter https://github.com/abhi152003/speedrun_stylus.git
   ```

   ```bash
   cd speedrun_stylus
   ```

   ```bash
   yarn install
   ```


4. Start the local devnode in Docker:

   ```bash
   cd packages/stylus-demo
   ```

   ```bash
   bash run-dev-node.sh
   ```

5. **Copy the contract address** from the bash terminal output. You will need to paste this address into the `contractAddress` variable in the `DebugContract` component.

> 💡 **Note**: If both contract addresses are the same, you don't need to do anything - you're ready to go and interact with the stylus-based smart contracts written in RUST!


![DockerImg](https://github.com/user-attachments/assets/04159bef-cc35-442f-b67a-5e8f7033db43)

<p align="center"><em>Docker_Img</em></p>

6. In a second WSL terminal window, start your frontend:

   ```bash
   cd speedrun_stylus/packages/nextjs
   ```

   ```bash
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

## 🚀 Submitting Your Challenge

After you have completed the setup and are ready to submit your solution, follow these steps:

1. **Create a New GitHub Repository**
   - Go to [GitHub](https://github.com/) and create a new repository (public or private as required by the challenge).

2. **Set Your Local Repository's Remote URL**
   - In your project directory, update the remote URL to your new repository:
     ```bash
     git remote set-url origin https://github.com/yourusername/your-repo.git
     ```

3. **Push Your Code to GitHub**
   - Add and commit any changes if you haven't already:
     ```bash
     git add .
     git commit -m "Initial commit for challenge submission"
     ```
   - Push your code:
     ```bash
     git push -u origin counter
     ```

4. **Submit Your Challenge**
   - Copy your repository link in the following format (without `.git` at the end):
     ```
     https://github.com/yourusername/your-repo
     ```
   - Use this link to submit your challenge as instructed.

---

## 💫 Checkpoint 1: Frontend Magic

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

🛰 You don't need to provide any specifications to deploy your contract because contracts are automatically deployed from the `run-dev-node.sh`

> You can check that below :

![image](https://github.com/user-attachments/assets/d84c4d6a-be20-426b-9c68-2c021caefb29)

The above command will automatically deploy the contract functions written inside `speedrun_stylus/packages/stylus-demo/src/lib.rs`

> This local account will deploy your contracts, allowing you to avoid entering a personal private key because the deployment happens using the pre-funded account's private key.

## Checkpoint 3: 🚢 Ship your frontend! 🚁

> We are deploying all the RUST contracts at the `localhost:8547` endpoint where the nitro devnode is spinning up in Docker. You can check the network where your contract has been deployed in the frontend (http://localhost:3000):

![image](https://github.com/user-attachments/assets/bb82e696-97b9-453e-a7c7-19ebb7bd607f)

🚀 Deploy your NextJS App

```bash
yarn vercel
```

> Follow the steps to deploy to Vercel. Once you log in (email, github, etc), the default options should work. It'll give you a public URL.

> If you want to redeploy to the same production URL you can run `yarn vercel --prod`. If you omit the `--prod` flag it will deploy it to a preview/test URL.

⚠️ Run the automated testing function to make sure your app passes

```bash
yarn test
```

---

## Checkpoint 4: 📜 Contract Verification

You can verify your smart contract by running:

```bash
cargo stylus verify -e http://127.0.0.1:8547 --deployment-tx "$deployment_tx"
```

```bash
cargo stylus deploy -e http://127.0.0.1:8547 --private-key "$your_private_key"
```

> It is okay if it says your contract is already verified.

---

> 🏃 Head to your next challenge [here](https://www.speedrunstylus.com/challenge/simple-nft-example).
