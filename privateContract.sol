pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;

contract InvestmentDataSharingPlatform {
    address regulatoryAuthority;
    mapping(string => mapping(string => address)) brokerIdSecuritiesAccountAddress;

    event shareSecuritiesAccountInvestmentInventoryUploaded(
        string brokerId,
        string securitiesAccount,
        string stockId,
        int256 numberOfShares
    );

    constructor() public {
        regulatoryAuthority = msg.sender;
    }

    function registerBrokerIdSecuritiesAccountAddress(
        string memory _brokerId,
        string memory _securitiesAccount,
        address _brokerIdAddress
    ) public {
        require(
            msg.sender == regulatoryAuthority,
            "You are not a regulator，[registerBrokerIdAddress] Error."
        );
        brokerIdSecuritiesAccountAddress[_brokerId][
            _securitiesAccount
        ] = address(_brokerIdAddress);
    }

    function uploadShareSecuritiesAccountInvestmentInventory(
        string memory _brokerId,
        string memory _securitiesAccount,
        string memory _stockId,
        int256 _numberOfShares
    ) public {
        require(
            brokerIdSecuritiesAccountAddress[_brokerId][_securitiesAccount] ==
                msg.sender,
            "You are not the broker of the securities account，[uploadShareSecuritiesAccountInvestmentPerformance] Error."
        );

        emit shareSecuritiesAccountInvestmentInventoryUploaded(
            _brokerId,
            _securitiesAccount,
            _stockId,
            _numberOfShares
        );
    }
}
