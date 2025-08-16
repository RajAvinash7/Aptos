# 📚 Homework Submission Hashes on Aptos

This project is a **full-stack blockchain demo** built for learning and meetups.  
It uses the **Aptos Move smart contract language** to allow students to submit their homework **off-chain** (Google Drive, IPFS, S3, etc.) but commit the **hash** of the file **on-chain**.  

This ensures:
- 🛡️ **Proof of originality** — anyone can verify if a file matches its submitted hash.  
- ⏳ **Proof of timing** — timestamp of the transaction proves *when* it was submitted.  
- 💡 **Lightweight storage** — only the hash is stored on-chain, not the whole file.  

---

## ✨ Features
- Students can **initialize their account** for submissions.  
- Students can **submit file hashes** to the blockchain.  
- The system proves:
  - ✅ Who submitted the work  
  - ✅ When it was submitted  
  - ✅ Integrity of the file  

---

## 📖 Smart Contract

The contract is intentionally simple (only **two functions**) for easy understanding and demos.  

```move
module MyModule::HomeworkSubmission {

    use aptos_framework::signer;
    use std::vector;

    /// Stores homework submission hashes
    struct Submissions has key {
        hashes: vector<vector<u8>>,
    }

    /// Initialize storage under the student's account
    public fun init_student(account: &signer) {
        move_to(account, Submissions { hashes: vector::empty<vector<u8>>() });
    }

    /// Submit a new homework hash
    public fun submit_homework(student: &signer, hash: vector<u8>) acquires Submissions {
        let submissions = borrow_global_mut<Submissions>(signer::address_of(student));
        vector::push_back(&mut submissions.hashes, hash);
    }
}
🛠️ Setup Instructions
1. Install Aptos CLI

Follow the official guide: Aptos CLI Installation

Verify installation:

aptos --version

2. Initialize Account

Create a local account (Devnet/Testnet):

aptos init


This generates keys and saves them in ~/.aptos/config.yaml.

3. Configure Named Address

In your Move.toml, set:

[addresses]
MyModule = "<your-account-address>"


This makes your contract reusable on any network without hardcoding.

4. Compile Contract
aptos move compile --named-addresses MyModule=<your-account-address>

5. Publish Contract
aptos move publish --named-addresses MyModule=<your-account-address> --profile default


If successful, your module is deployed on-chain under your account address. 🎉

📥 Usage Examples
1. Initialize Student

Each student sets up storage once:

aptos move run \
  --function-id <your-account-address>::HomeworkSubmission::init_student \
  --profile default

2. Submit Homework Hash

Hash your homework file:

shasum -a 256 my_homework.pdf
# output: 3f785a4e23f8d91c... (this is the hash)


Submit the hash on-chain:

aptos move run \
  --function-id <your-account-address>::HomeworkSubmission::submit_homework \
  --args vector<u8>:0x3f785a4e23f8d91c... \
  --profile default

3. Verify Submission

Anyone can recompute the hash of a file and check if it matches the on-chain record.
This ensures authenticity and no tampering.

🌐 Workflow Summary

🧑‍🎓 Student uploads homework to IPFS/Drive/etc.

🔑 Student computes SHA-256 hash of file.

⛓️ Student commits hash to Aptos blockchain.

✅ Verification: recompute hash from file → match with on-chain hash.

🎯 Future Enhancements

Add assignment creation by instructors.

Store deadlines and reject late submissions.

Emit events for easy indexing and dashboards.

Add versioning (multiple submissions allowed).

Build a React frontend for file selection, hashing, and submission.

👨‍💻 Author

Developed with ❤️ by Avinash Raj
