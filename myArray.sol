// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Array {
    function sort(uint[] storage arr) internal {
        for (uint i = 0; i < arr.length - 1; i++) {
            for (uint j = 0; j < arr.length - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    uint tmp = arr[j];
                    arr[j] = arr[j+1];
                    arr[j+1] = tmp;
                }
            }
        }
    }

    function removeDuplicates(uint[] storage arr) internal {
        for(uint i = 0; i < arr.length - 1; i++){
            for (uint j = i+1; j < arr.length - 1; j++){
                if(arr[i]==arr[j]){
                    delete arr[i];
                }
            }
        }
        sort(arr);
        uint countor = 0;
        for(uint i = 0; i < arr.length - 1; i++){
            if(arr[i] == 0){
                countor = countor + 1;
            }
        }
        for(uint i = 0; i < countor - 1; i++){
            uint tmp = arr[i];
            arr[i] = arr[arr.length-1-i];
            arr[arr.length-1-i] = tmp;
        }
        for(uint i = 0; i < countor - 1; i++){
            arr.pop();
        }
    }
}


contract Lab1 {
    using Array for uint[];

    uint[] public data = [6,2,7,5,1,6,4,0,9,3];

    function sortData() public {
        data.sort();
    }

    function removeDuplicatesFromData() public {
        data.removeDuplicates();
    }
}
