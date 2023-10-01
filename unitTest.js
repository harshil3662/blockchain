const Lending = artifacts.require("Lending");
const MockToken = artifacts.require("TokenA"); // Use a mock token for testing

contract("Lending", (accounts) => {
    let lending;
    let token;
    const owner = accounts[0];
    const user1 = accounts[1];

    beforeEach(async () => {
        token = await MockToken.new({ from: owner });
        lending = await Lending.new(token.address, { from: owner });
    });

    it("should allow a user to deposit and check balances", async () => {
        const depositAmount = web3.utils.toBN(web3.utils.toWei("100", "ether"));
        await token.transfer(user1, depositAmount, { from: owner });

        // User1 approves Lending contract to spend tokens
        await token.approve(lending.address, depositAmount, { from: user1 });

        // User1 deposits tokens
        await lending.deposit(depositAmount, { from: user1 });

        // Check user's balance and total liquidity
        const user1Balance = await lending.balances(user1);
        const totalLiquidity = await lending.totalLiquidity();

        assert.equal(user1Balance.toString(), depositAmount.toString(), "User balance should match deposit amount");
        assert.equal(totalLiquidity.toString(), depositAmount.toString(), "Total liquidity should match deposit amount");
    });

    it("should allow a user to borrow and check balances", async () => {
        const depositAmount = web3.utils.toBN(web3.utils.toWei("100", "ether"));
        const borrowAmount = web3.utils.toBN(web3.utils.toWei("50", "ether"));
        await token.transfer(user1, depositAmount, { from: owner });
        await token.approve(lending.address, depositAmount, { from: user1 });
        await lending.deposit(depositAmount, { from: user1 });

        // User1 borrows tokens
        await lending.borrow(borrowAmount, { from: user1 });

        // Check user's balance and total liquidity
        const user1Balance = await lending.balances(user1);
        const totalLiquidity = await lending.totalLiquidity();

        assert.equal(user1Balance.toString(), (depositAmount - borrowAmount).toString(), "User balance should match deposit - borrow");
        assert.equal(totalLiquidity.toString(), (depositAmount - borrowAmount).toString(), "Total liquidity should match deposit - borrow");
    });

    it("should revert when a user attempts to borrow more than available liquidity", async () => {
        const depositAmount = web3.utils.toBN(web3.utils.toWei("100", "ether"));
        const borrowAmount = web3.utils.toBN(web3.utils.toWei("150", "ether")); // Borrow more than available

        await token.transfer(user1, depositAmount, { from: owner });
        await token.approve(lending.address, depositAmount, { from: user1 });
        await lending.deposit(depositAmount, { from: user1 });

        // Attempt to borrow more than available liquidity
        try {
            await lending.borrow(borrowAmount, { from: user1 });
            assert.fail("Should revert when attempting to borrow more than available liquidity");
        } catch (error) {
            assert(error.message.includes("revert"), "Expected revert error");
        }
    });
});
