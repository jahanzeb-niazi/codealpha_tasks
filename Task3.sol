// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract VotingPoll {
    struct Poll {
        string title;
        string[] options;
        uint256 endTime;
        mapping(uint => uint) voteCounts;
        mapping(address => bool) hasVoted;
        bool exists;
    }

    uint256 public pollIdCounter;
    mapping(uint256 => Poll) public polls;

    event PollCreated(uint256 pollId, string title, uint256 endTime);
    event Voted(uint256 pollId, uint256 optionId);
    event WinnerAnnounced(uint256 pollId, uint256 winningOptionId);

    modifier pollExists(uint256 pollId) {
        require(polls[pollId].exists, "Poll does not exist");
        _;
    }

    modifier beforeDeadline(uint256 pollId) {
        require(block.timestamp < polls[pollId].endTime, "Poll has ended");
        _;
    }

    function createPoll(
        string memory _title,
        string[] memory _options,
        uint256 _durationInSeconds
    ) external {
        require(_options.length > 0, "Poll must have at least one option");
        require(
            _durationInSeconds >= 60,
            "Poll duration must be at least 1 minute"
        ); //optional
        Poll storage newPoll = polls[pollIdCounter];
        newPoll.title = _title;
        newPoll.options = _options;
        newPoll.endTime = block.timestamp + _durationInSeconds;
        newPoll.exists = true;

        emit PollCreated(pollIdCounter, _title, newPoll.endTime);
        pollIdCounter++;
    }

    function vote(
        uint256 _pollId,
        uint256 _optionId
    ) external pollExists(_pollId) beforeDeadline(_pollId) {
        Poll storage poll = polls[_pollId];
        require(!poll.hasVoted[msg.sender], "Address has already voted");
        require(_optionId < poll.options.length, "Invalid option");

        poll.voteCounts[_optionId]++;
        poll.hasVoted[msg.sender] = true;

        emit Voted(_pollId, _optionId);
    }

    function getWinningOption(
        uint256 _pollId
    ) external pollExists(_pollId) returns (string memory) {
        require(
            block.timestamp >= polls[_pollId].endTime,
            "Poll is still active"
        );

        Poll storage poll = polls[_pollId];
        uint256 winningOptionId = 0;
        uint256 highestVotes = 0;

        for (uint256 i = 0; i < poll.options.length; i++) {
            if (poll.voteCounts[i] == highestVotes && poll.voteCounts[i] > 0) {
                return "Tie";
            }
            if (poll.voteCounts[i] > highestVotes) {
                highestVotes = poll.voteCounts[i];
                winningOptionId = i;
            }
        }

        emit WinnerAnnounced(_pollId, winningOptionId);
        return polls[_pollId].options[winningOptionId];
    }

    function getOptions(
        uint256 _pollId
    ) external view pollExists(_pollId) returns (string[] memory) {
        return polls[_pollId].options;
    }

    function getVoteCount(
        uint256 _pollId,
        uint256 _optionId
    ) external view pollExists(_pollId) returns (uint256) {
        return polls[_pollId].voteCounts[_optionId];
    }

    function hasAddressVoted(
        uint256 _pollId,
        address _voter
    ) external view pollExists(_pollId) returns (bool) {
        return polls[_pollId].hasVoted[_voter];
    }
}
