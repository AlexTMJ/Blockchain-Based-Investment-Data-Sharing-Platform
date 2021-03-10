pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;

contract InvestmentDataSharingPlatform {
    struct ShareSecuritiesAccountProperty {
        bool sharedStatus;
        string month;
        uint256 subscribeAmount;
    }

    address regulatoryAuthority;

    mapping(string => mapping(string => address)) brokerIdSecuritiesAccountAddress;
    mapping(string => mapping(string => ShareSecuritiesAccountProperty)) shareAccount;

    event securitiesAccountShared(
        string brokerId,
        string securitiesAccount,
        string month,
        bool sharedStatus,
        uint256 subscribeAmount,
        uint256 time
    );
    event securitiesAccountCanceled(
        string brokerId,
        string securitiesAccount,
        bool sharedStatus,
        uint256 time
    );
    event securitiesAccountSubscribeAmountUpdated(
        string brokerId,
        string securitiesAccount,
        uint256 subscribeAmount
    );

    event shareSecuritiesAccountSubscribed(
        string subscribeBrokerId,
        string subscriberIdHash,
        string shareBrokerId,
        string shareSecuritiesAccount,
        string startDate,
        string dueDate,
        uint256 totalSubscribeAmount
    );
    event shareSecuritiesAccountInvestmentPerformanceUploaded(
        string brokerId,
        string securitiesAccount,
        string date,
        string monthROI,
        string averageHoldingTime,
        string averageProfit,
        string averageLoss,
        string winPercentage
    );
    event shareSecuritiesAccountInvestmentInventoryUploaded(
        string brokerId,
        string securitiesAccount,
        string stockId,
        int256 numberOfShares
    );

    constructor() public {
        regulatoryAuthority = msg.sender;
    }

    //交由監管機構設定  broker ethereum address
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

    function shareSecuritiesAccount(
        string memory _brokerId,
        string memory _securitiesAccount,
        string memory _month,
        uint256 _subscribeAmount
    ) public {
        require(
            brokerIdSecuritiesAccountAddress[_brokerId][_securitiesAccount] ==
                msg.sender,
            "You are not the broker of the securities account，[shareSecuritiesAccount] Error."
        );
        require(
            shareAccount[_brokerId][_securitiesAccount].sharedStatus == false,
            "shared status of securities account must be false，[shareSecuritiesAccount] Error."
        );

        shareAccount[_brokerId][_securitiesAccount].sharedStatus = true;
        shareAccount[_brokerId][_securitiesAccount].month = _month;
        shareAccount[_brokerId][_securitiesAccount]
            .subscribeAmount = _subscribeAmount;

        emit securitiesAccountShared(
            _brokerId,
            _securitiesAccount,
            _month,
            true,
            _subscribeAmount,
            now
        );
    }

    function cancelShareSecuritiesAccount(
        string memory _brokerId,
        string memory _securitiesAccount
    ) public {
        require(
            brokerIdSecuritiesAccountAddress[_brokerId][_securitiesAccount] ==
                msg.sender,
            "You are not the broker of the securities account，[cancelShareSecuritiesAccount] Error."
        );
        require(
            shareAccount[_brokerId][_securitiesAccount].sharedStatus == true,
            "shared status of securities account must be true，[cancelShareSecuritiesAccount] Error."
        );

        shareAccount[_brokerId][_securitiesAccount].sharedStatus = false;
        shareAccount[_brokerId][_securitiesAccount].subscribeAmount = 0;

        emit securitiesAccountCanceled(
            _brokerId,
            _securitiesAccount,
            false,
            now
        );
    }

    function updateShareSecuritiesAccountSubscribeAmount(
        string memory _brokerId,
        string memory _securitiesAccount,
        uint256 _subscribeAmount
    ) public {
        require(
            brokerIdSecuritiesAccountAddress[_brokerId][_securitiesAccount] ==
                msg.sender,
            "You are not the broker of the securities account，[updateShareSecuritiesAccountSubscribeAmount] Error."
        );
        require(
            shareAccount[_brokerId][_securitiesAccount].sharedStatus == true,
            "shared status of securities account must be true，[updateShareSecuritiesAccountSubscribeAmount] Error."
        );

        shareAccount[_brokerId][_securitiesAccount]
            .subscribeAmount = _subscribeAmount;

        emit securitiesAccountSubscribeAmountUpdated(
            _brokerId,
            _securitiesAccount,
            _subscribeAmount
        );
    }

    function subscribeShareSecuritiesAccount(
        string memory _subscribeBrokerId,
        string memory _subscriberIdHash,
        string memory _shareBrokerId,
        string memory _shareSecuritiesAccount,
        string memory _startDate,
        string memory _dueDate,
        uint256 _totalSubscribeAmount
    ) public {
        require(
            shareAccount[_shareBrokerId][_shareSecuritiesAccount]
                .sharedStatus == true,
            "shared status of securities account must be true，[subscribeShareSecuritiesAccount] Error."
        );

        emit shareSecuritiesAccountSubscribed(
            _subscribeBrokerId,
            _subscriberIdHash,
            _shareBrokerId,
            _shareSecuritiesAccount,
            _startDate,
            _dueDate,
            _totalSubscribeAmount
        );
    }

    function uploadShareSecuritiesAccountInvestmentPerformance(
        string memory _brokerId,
        string memory _securitiesAccount,
        string memory date,
        string memory _monthROI,
        string memory _averageHoldingTime,
        string memory _averageProfit,
        string memory _averageLoss,
        string memory _winPercentage
    ) public {
        require(
            brokerIdSecuritiesAccountAddress[_brokerId][_securitiesAccount] ==
                msg.sender,
            "You are not the broker of the securities account，[uploadShareSecuritiesAccountInvestmentPerformance] Error."
        );
        require(
            shareAccount[_brokerId][_securitiesAccount].sharedStatus == true,
            "shared status of securities account must be true，[uploadShareSecuritiesAccountInvestmentPerformance] Error."
        );

        emit shareSecuritiesAccountInvestmentPerformanceUploaded(
            _brokerId,
            _securitiesAccount,
            date,
            _monthROI,
            _averageHoldingTime,
            _averageProfit,
            _averageLoss,
            _winPercentage
        );
    }

    // function uploadShareSecuritiesAccountInvestmentInventory(
    //     string memory _brokerId,
    //     string memory _securitiesAccount,
    //     string memory _stockId,
    //     int256 _numberOfShares
    // ) public {
    //     require(
    //         brokerIdSecuritiesAccountAddress[_brokerId][_securitiesAccount] ==
    //             msg.sender,
    //         "You are not the broker of the securities account，[uploadShareSecuritiesAccountInvestmentInventory] Error."
    //     );
    //     require(
    //         shareAccount[_brokerId][_securitiesAccount].sharedStatus == true,
    //         "shared status of securities account must be true，[uploadShareSecuritiesAccountInvestmentInventory] Error."
    //     );

    //     emit shareSecuritiesAccountInvestmentInventoryUploaded(
    //         _brokerId,
    //         _securitiesAccount,
    //         _stockId,
    //         _numberOfShares
    //     );
    // }
}
