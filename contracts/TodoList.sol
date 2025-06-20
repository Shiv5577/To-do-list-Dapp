// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TodoList {
    struct Task {
        uint id;
        string content;
        bool completed;
    }

    uint private taskCounter;
    mapping(address => Task[]) private userTasks;

    event TaskCreated(address indexed user, uint taskId, string content);
    event TaskCompleted(address indexed user, uint taskId);
    event TaskDeleted(address indexed user, uint taskId);

    function createTask(string memory _content) public {
        Task memory newTask = Task({
            id: taskCounter,
            content: _content,
            completed: false
        });
        userTasks[msg.sender].push(newTask);
        emit TaskCreated(msg.sender, taskCounter, _content);
        taskCounter++;
    }

    function getMyTasks() public view returns (Task[] memory) {
        return userTasks[msg.sender];
    }

    function completeTask(uint _taskId) public {
        Task[] storage tasks = userTasks[msg.sender];
        require(_taskId < tasks.length, "Invalid task ID");
        tasks[_taskId].completed = true;
        emit TaskCompleted(msg.sender, _taskId);
    }

    function deleteTask(uint _taskId) public {
        Task[] storage tasks = userTasks[msg.sender];
        require(_taskId < tasks.length, "Invalid task ID");
        for (uint i = _taskId; i < tasks.length - 1; i++) {
            tasks[i] = tasks[i + 1];
        }
        tasks.pop();
        emit TaskDeleted(msg.sender, _taskId);
    }
}
