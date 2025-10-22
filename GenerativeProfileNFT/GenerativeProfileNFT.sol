// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title GenerativeProfileNFT
/// @notice On-chain trait storage + minting with randomness seed (pseudo)
contract GenerativeProfileNFT {
    string public name = "GenProfile";
    string public symbol = "GPN";
    uint256 public totalSupply;
    uint256 public maxSupply;
    mapping(uint256 => address) public ownerOf;
    mapping(uint256 => uint256) public seed; // on-chain seed for generative traits

    event Mint(address indexed to, uint256 indexed id, uint256 seedVal);

    constructor(uint256 _maxSupply) {
        maxSupply = _maxSupply;
    }

    function mint(uint256 n) external payable {
        require(totalSupply + n <= maxSupply, "exceed");
        for(uint256 i=0;i<n;i++){
            uint256 id = totalSupply + 1;
            uint256 s = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, id)));
            seed[id] = s;
            ownerOf[id] = msg.sender;
            totalSupply = id;
            emit Mint(msg.sender, id, s);
        }
    }

    function traitsOf(uint256 id) public view returns (string memory) {
        require(ownerOf[id] != address(0), "no token");
        uint256 s = seed[id];
        // simple deterministic traits derived from seed
        string memory palette = (s % 2 == 0) ? "dark" : "light";
        string memory shape = (s % 3 == 0) ? "circle" : (s % 3 == 1 ? "square" : "triangle");
        return string(abi.encodePacked("{"palette":"", palette, "","shape":"", shape, ""}"));
    }
}
