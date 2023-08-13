// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Upload
{
    struct Access
    {
        address user;
        bool access;
    }
    //creating data base to store data
    mapping(address=>string[] )value;
    mapping(address=>mapping(address=>bool))ownership;
    mapping(address=>Access[])accessList;
    mapping(address=>mapping(address=>bool))previousData;
    //Function to add user data and url 
    function add( address _user, string memory url) external
    {
        value[_user].push(url);

    }
    //function to allow access to other users
    function allow(address user) external 
    {
        ownership[msg.sender][user] = true;//here msg.sender us user ka address daal raha hai jo smart contract access kar raha hai aur user hamara added user addres hai
        if(previousData[msg.sender][user])//this works coz boolean value is stored in it
        {
            for(uint i =0;i<accessList[msg.sender].length;i++ )
            {
                if(accessList[msg.sender][i].user ==user)
                {
                    accessList[msg.sender][i].access = true;
                }
            }

        }
        else 
        {
            accessList[msg.sender].push (Access(user,true));
            previousData[msg.sender][user] = true;
        }

       
        

    }
    function disAllow(address user)external
    {
        ownership[msg.sender][user] = false;
        for(uint i =0;i<accessList[msg.sender].length;i++ )
        {
            if(accessList[msg.sender][i].user ==user)
            {
                accessList[msg.sender][i].access = false;
            }
        }
    }

    function display(address _user) view external returns(string[] memory) 
    {
        require(_user == msg.sender || ownership[_user][msg.sender],"You don't have the access");
        return value[_user];
    }

    function shareAddress() public view returns(Access[] memory)
    {
        return accessList[msg.sender];
    }






}