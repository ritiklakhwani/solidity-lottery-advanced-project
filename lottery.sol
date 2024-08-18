// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address[] public participants;
    uint256 public ticketPrice = 2 ether;
    uint256 public lotteryEndTime;
    bool public lotteryCanceled = false;
    mapping(address => uint256) public ticketsBought;

    event TicketPurchased(address indexed participant, uint256 amount);
    event WinnerSelected(address indexed winner, uint256 amountWon);
    event LotteryReset();
    event LotteryCanceled();

    constructor() {
        manager = msg.sender; 
        lotteryEndTime = block.timestamp + 1 weeks; // lottery will run for one week
    }

    function buyTicket() public payable {
        require(!lotteryCanceled, "Lottery has been canceled.");
        require(block.timestamp < lotteryEndTime, "Lottery has ended.");
        require(msg.value == ticketPrice, "Incorrect ticket price.");
        require(ticketsBought[msg.sender] < 5, "Cannot buy more than 5 tickets."); // limit to 5 tickets per participant

        participants.push(msg.sender);
        ticketsBought[msg.sender]++;
        emit TicketPurchased(msg.sender, msg.value); 
    }

    function pickWinner() public onlyManager {
        require(block.timestamp >= lotteryEndTime, "Lottery time is not yet over.");
        require(participants.length >= 3, "There must be at least 3 participants to pick a winner.");

        uint randomIndex = random() % participants.length;
        address winner = participants[randomIndex];

        uint256 prizeAmount = address(this).balance;
        payable(winner).transfer(prizeAmount);

        emit WinnerSelected(winner, prizeAmount); // winner selection

        resetLottery(); // reset lottery 
        lotteryEndTime = block.timestamp + 1 weeks; 
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants)));
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can call this function.");
        _;
    }

    function getParticipantsCount() public view returns (uint) {
        return participants.length;
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function resetLottery() public onlyManager {
        delete participants;
        for (uint i = 0; i < participants.length; i++) {
            ticketsBought[participants[i]] = 0; 
        }
        emit LotteryReset(); 
    }

    function setTicketPrice(uint256 newPrice) public onlyManager {
        require(newPrice > 0, "Ticket price must be greater than 0.");
        ticketPrice = newPrice;
    }

    function cancelLottery() public onlyManager {
        lotteryCanceled = true;
        emit LotteryCanceled();
    }

    function withdraw() public {
        require(lotteryCanceled, "Lottery is not canceled.");
        require(ticketsBought[msg.sender] > 0, "No tickets bought.");

        uint256 refundAmount = ticketsBought[msg.sender] * ticketPrice;
        ticketsBought[msg.sender] = 0;
        payable(msg.sender).transfer(refundAmount);
    }
}