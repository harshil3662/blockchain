const BridgeA = artifacts.require("BridgeA");
const TokenA = artifacts.require("TokenA");

contract("BridgeA", (accounts) => {
    let bridgeA;
    let tokenA;

    const sender = accounts[0];
    const receiver = accounts[1];

    beforeEach(async () => {
        tokenA = await TokenA.new();
        bridgeA = await BridgeA.new(tokenA.address,"0xf8e81D47203A594245E36C48e151709F0C19fBe8");
    });

    it("should lock and unlock tokens", async () => {
        const amountToLock = web3.utils.toBN(web3.utils.toWei("1", "ether"));

        await tokenA.approve(bridgeA.address, amountToLock, { from: sender });
        await bridgeA.lockTokens(amountToLock, { from: sender });

        const bridgeABalance = await tokenA.balanceOf(bridgeA.address);
        assert.equal(bridgeABalance.toString(), amountToLock.toString(), "BridgeA should hold the locked tokens");

        await bridgeA.unlockTokens(amountToLock, receiver, { from: sender });

        const receiverBalance = await tokenA.balanceOf(receiver);
        assert.equal(receiverBalance.toString(), amountToLock.toString(), "Receiver should have received the unlocked tokens");
    });
});
