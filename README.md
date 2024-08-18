# Lottery Smart Contract
view contract on etherscan - https://sepolia.etherscan.io/address/0x3dcd575aa1c16cdb92825427b2666c1a5cbb3f2b#code

This is a Solidity smart contract for a decentralized lottery system on the Ethereum blockchain. Participants can buy lottery tickets, and a random winner is selected after a certain time.

## Features

- **Managed by a Manager**: Only the manager can control important functions like choosing a winner, resetting the lottery, setting ticket prices, and canceling the lottery.
- **Buying Tickets**: Participants can buy tickets for 2 Ether each, with a limit of 5 tickets per person.
- **Random Winner**: A random winner is selected once the lottery ends (default is 1 week).
- **Set Ticket Price**: The manager can change the ticket price.
- **Refund Option**: If the lottery is canceled, participants can get their money back.
- **Event Logging**: Important actions like ticket purchases, winner selection, and lottery resets are recorded as events.

## How It Works

1. **Buy Tickets**: Send 2 Ether to the contract to buy a ticket.
2. **Pick a Winner**: After 1 week, the manager can pick a random winner.
3. **Payout**: The winner receives all the Ether in the contract.
4. **Reset**: The lottery is reset for the next round after picking a winner.

## Requirements

- Solidity `^0.8.0`
- An Ethereum wallet (like MetaMask)

## Deployment

You can deploy this contract using Remix or another Solidity development tool on an Ethereum testnet or mainnet.

## License

This project is licensed under the MIT License.
