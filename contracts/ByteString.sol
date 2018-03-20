pragma solidity ^0.4.19;

contract BytesString {

    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
            assembly {
                result := mload(add(source, 32))
            }
    }

    function bytes32ToStr(bytes32 _bytes32) internal pure returns (string){
        bytes memory bytesArray = new bytes(32);
        for (uint256 i; i < 32; i++) {
            bytesArray[i] = _bytes32[i];
            }
        return string(bytesArray);
    }

}