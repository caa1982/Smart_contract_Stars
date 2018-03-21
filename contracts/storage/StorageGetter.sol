pragma solidity ^0.4.19;

import "./Storage.sol";
import "../../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";

contract StorageGetter is Storage {

    /**
    * @dev Gets the total amount of tokens stored by the contract
    * @return uint256 representing the total amount of tokens
    */
    function totalSupply() public view returns (uint256) {
        return totalTokens;
    }

    /**
    * @dev Gets the balance of the specified address
    * @param _owner address to query the balance of
    * @return uint256 representing the amount owned by the passed address
    */
    function balanceOf(address _owner) public view returns (uint256) {
        return ownedTokens[_owner].length;
    }

    /**
    * @dev Gets the list of tokens owned by a given address
    * @param _owner address to query the tokens of
    * @return uint256[] representing the list of tokens owned by the passed address
    */
    function tokensOf(address _owner) public view returns (uint256[]) {
        return ownedTokens[_owner];
    }

    /**
    * @dev Gets the owner of the specified token ID
    * @param _tokenId uint256 ID of the token to query the owner of
    * @return owner address currently marked as the owner of the given token ID
    */
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = tokens[_tokenId].tokenOwner;
        require(owner != address(0));
        return owner;
    }

    /**
    * @dev Gets the approved address to take ownership of a given token ID
    * @param _tokenId uint256 ID of the token to query the approval of
    * @return address currently approved to take ownership of the given token ID
    */
    function approvedFor(uint256 _tokenId) public view returns (address) {
        return tokens[_tokenId].tokenApproval;
    }

    function tokenPriceOf(uint256 _tokenId) external view returns (uint) {
        uint price = tokens[_tokenId].tokenPrice;
        require(price > 0);
        return price;
    }

    function tokenNameOf(uint256 _tokenId) external view returns (string) {
        bytes32 name = tokens[_tokenId].tokenName;
        return bytes32ToStr(name);
    }

    function tokenDetailsOf(uint256 _tokenId) external view returns (address, uint, string, address) {
        return (
            tokens[_tokenId].tokenOwner, 
            tokens[_tokenId].tokenPrice,
            bytes32ToStr(tokens[_tokenId].tokenName),
            tokens[_tokenId].tokenApproval
            );
    }

    function bytes32ToStr(bytes32 _bytes32) internal pure returns (string){
        bytes memory bytesArray = new bytes(32);
        for (uint256 i; i < 32; i++) {
            bytesArray[i] = _bytes32[i];
            }
        return string(bytesArray);
    }

}