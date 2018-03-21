pragma solidity ^0.4.18;

import "../../node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "../../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";
import ".././storage/Storage.sol";

/**
 * @title ERC721Token
 * Generic implementation for the required functionality of the ERC721 standard
 */
contract ERC721Token is ERC721 {
    using SafeMath for uint256;

    Storage tokenStorage;

    function ERC721Token(address _tokenStorageAddress) public {
        tokenStorage = Storage(_tokenStorageAddress);
    }
    
    /**
    * @dev Guarantees msg.sender is owner of the given token
    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
    */
    modifier onlyOwnerOf(uint256 _tokenId) {
        require(tokenStorage.ownerOf(_tokenId) == msg.sender);
        _;
    }

    /**
    * @dev Transfers the ownership of a given token ID to another address
    * @param _to address to receive the ownership of the given token ID
    * @param _tokenId uint256 ID of the token to be transferred
    */
    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        clearApprovalAndTransfer(msg.sender, _to, _tokenId);
    }

    /**
    * @dev Approves another address to claim for the ownership of the given token ID
    * @param _to address to be approved for the given token ID
    * @param _tokenId uint256 ID of the token to be approved
    */
    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        address owner = ownerOf(_tokenId);
        require(_to != owner);
        if (tokenStorage.approvedFor(_tokenId) != 0 || _to != 0) {
            tokenStorage.changeTokenApproval(_tokenId, _to);
            Approval(owner, _to, _tokenId);
        }
    }

    /**
    * @dev Tells whether the msg.sender is approved for the given token ID or not
    * This function is not private so it can be extended in further implementations like the operatable ERC721
    * @param _owner address of the owner to query the approval of
    * @param _tokenId uint256 ID of the token to query the approval of
    * @return bool whether the msg.sender is approved for the given token ID or not
    */
    function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
        return tokenStorage.approvedFor(_tokenId) == _owner;
    }

    /**
    * @dev Claims the ownership of a given token ID
    * @param _tokenId uint256 ID of the token being claimed by the msg.sender
    */
    function takeOwnership(uint256 _tokenId) public {
        require(isApprovedFor(msg.sender, _tokenId));
        clearApprovalAndTransfer(tokenStorage.ownerOf(_tokenId), msg.sender, _tokenId);
    }

    /**
    * @dev Internal function to clear current approval and transfer the ownership of a given token ID
    * @param _from address which you want to send tokens from
    * @param _to address which you want to transfer the token to
    * @param _tokenId uint256 ID of the token to be transferred
    */
    function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0));
        require(_to != ownerOf(_tokenId));
        require(ownerOf(_tokenId) == _from);

        clearApproval(_from, _tokenId);
        removeToken(_from, _tokenId);
        addToken(_to, _tokenId);
        Transfer(_from, _to, _tokenId);
    }

    /**
    * @dev Internal function to clear current approval of a given token ID
    * @param _tokenId uint256 ID of the token to be transferred
    */
    function clearApproval(address _owner, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _owner);
        tokenStorage.changeTokenApproval(_tokenId, 0);
        Approval(_owner, 0, _tokenId);
    }

    /**
    * @dev Internal function to add a token ID to the list of a given address
    * @param _to address representing the new owner of the given token ID
    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
    */
    function addToken(address _to, uint256 _tokenId) internal {
        tokenStorage.changeTokenOwner(_tokenId, _to);
        uint256 length = tokenStorage.balanceOf(_to);
        tokenStorage.pushOwnedTokens(_tokenId, _to);
        tokenStorage.changeOwnedTokensIndex(_tokenId, length);
        tokenStorage.addTotalTokens(1);
    }

    /**
    * @dev Internal function to remove a token ID from the list of a given address
    * @param _from address representing the previous owner of the given token ID
    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
    */
    function removeToken(address _from, uint256 _tokenId) internal {
        tokenStorage.changeTokenOwner(_tokenId, 0);
        tokenStorage.changeLastTokenOwned(_from, _tokenId);

        tokenStorage.changeLastOwnedTokensIndex(_from, _tokenId);
        tokenStorage.subTotalTokens(1);
    }
}