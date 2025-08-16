module MyModule::HomeworkSubmission {

    use aptos_framework::signer;
    use std::vector;

    /// Struct to store a student's homework submission hashes
    struct Submissions has key {
        hashes: vector<vector<u8>>,  // List of submitted hashes
    }

    /// Initialize a Submissions resource under the student's account
    public fun init_student(account: &signer) {
        move_to(account, Submissions { hashes: vector::empty<vector<u8>>() });
    }

    /// Submit a new homework hash (stored off-chain, hash only kept here)
    public fun submit_homework(student: &signer, hash: vector<u8>) acquires Submissions {
        let submissions = borrow_global_mut<Submissions>(signer::address_of(student));
        vector::push_back(&mut submissions.hashes, hash);
    }
}
