const PermitToken = artifacts.require("PermitToken");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("PermitToken", function ( accounts ) {
  it("should assert true", async function () {
    await PermitToken.deployed();
    return assert.isTrue(true);
  });

  describe("mint", ()=>{
    it("Should mint tokens to an account", async()=>{
      const instance = await PermitToken.deployed();
      await instance.mint(accounts[0], 100);
      const balanceOfAccount0 = await instance.balanceOf(accounts[0]);

      assert.equal(balanceOfAccount0.toNumber(), 100);
    })
  })

  describe("permit", ()=>{
    it("should permit valid", async()=>{
      const instance = await PermitToken.deployed();
      await instance.permit(accounts[0], accounts[1],5, 12345678, true, 2,1,4); 
    })
  })

});
