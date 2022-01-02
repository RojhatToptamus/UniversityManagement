// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;
pragma experimental ABIEncoderV2;

contract UniversityContract{   
    address owner;
    constructor(){
        owner = msg.sender;
        courses[101] = Course(101, 1, "Math");
        courses[102] = Course(102, 1, "Computer Networks");
        courses[103] = Course(103, 1, "Theory of Computation");

     
        _addTeacher( 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 111, "Lecturer-1");
        _addTeacher( 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db, 112, "Lecturer-2");

        _addStudent( 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB, 911, 123, "Rojhat");
        _addStudent( 0x617F2E2fD72FD9D5503197092aC168c91465E7f2, 912, 124, "Mike");

        _addFaculty(10, "Faculty of Engineering");
        _addFaculty(11, "faculty of Architecture");
        _addFaculty(12, "faculty of Economics");

        _addDepartment(10, 910, "Computer Science");
        _addDepartment(11, 911, "Interior architecture");
        _addDepartment(12, 912, "Business Administration");

        _assignCoursesToTeacher(111, 101);
        _assignCoursesToTeacher(111, 102);
        _assignCoursesToTeacher(112, 103);

        _assignCoursesToStudent(123, 101);
        _assignCoursesToStudent(123, 102);
        _assignCoursesToStudent(123, 103);

        _assignCoursesToStudent(124, 101);
        _assignCoursesToStudent(124, 103);
     

        

      /*
        1) 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4  Owner
        2) 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2  Lecturer-1
        3) 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db   Lecturer-2
        4) 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB  Student-1
        5) 0x617F2E2fD72FD9D5503197092aC168c91465E7f2   Student-2
      */
    } 
    modifier onlyOwner(){
           require(msg.sender == owner, "You are not authorized for this action!");
            _;
        }
   
    struct University{
        uint uniCode;
        string uniName;
    }
    struct TeachingStaff{
        address teacherAddress;
        uint teacherCode;
        string teacherName;
        uint [] givenCourses;
        
    }
    struct Mark{
        uint courseCode;
        uint givenMark;
    }    
    struct  Student{
        address studentAddress;
        uint studentCode;
        string studentName;
        uint [] enrolledCourses;
        mapping (uint => Mark) studentCourseMarks;
        uint departmentId;
        Mark[] studentMarks;
      
        
    }
    function getAllMarks(address studentAddress)public view returns (Mark[] memory){
        Student storage a = students[studentAddress];
        return a.studentMarks;
        
    }
    struct Course{
        uint courseCode;
        uint departmentCode;
        string courseName;
   
    }
    struct Faculty{
        uint facultyCode;
        string facultyName;

    }  
    struct Department{
        uint departmentCode;
        string departmentName;
        
    }
    
    mapping(uint => Course) public courses;
    mapping(address => mapping( uint => Course)) public studentCourses;
    mapping(address => Student) public students;
    mapping(uint => address) public studentIdtoAddress;
    mapping(address => TeachingStaff) public teachers;
    mapping(uint => address) public teacherIdtoAddress;
    mapping(address => mapping( uint => bool)) public teacherCourses;
    //update
    mapping(uint =>Department) public departments;
    mapping(uint => Faculty) public faculties;
    mapping(uint=> mapping( uint => Faculty)) public departmentToFaculty;
    
  
    function _addFaculty(uint _facultyCode, string memory _facultyName)public onlyOwner{
        //check if faculty exist
        require(faculties[_facultyCode].facultyCode != _facultyCode, "Faculty already exists");     

        faculties[_facultyCode] = Faculty(_facultyCode, _facultyName);
    }
    
    function _addDepartment(uint _facultyCode, uint _departmentCode, string memory _departmentName) public onlyOwner{
        //check if faculty exist
        require(departments[_departmentCode].departmentCode != _departmentCode, "Department already exists");     

        departments[_departmentCode] = Department(_departmentCode, _departmentName);
        Faculty memory departmentFaculty = faculties[_facultyCode];
        departmentToFaculty[_departmentCode][_facultyCode] = departmentFaculty;
    }

    function _addCourse(uint _courseCode, uint _facultyCode, string memory _courseName ) public onlyOwner{
        //check if the course  exist
        require(courses[_courseCode].courseCode != _courseCode, "Course already added!");
        courses[_courseCode] = Course(_courseCode, _facultyCode, _courseName);
    }

    function _addStudent(address _studentAddress, uint _departmentId, uint _studentCode, string memory _studentName) public onlyOwner{
        // check if the student exists
        require(studentIdtoAddress[_studentCode] == address(0), "Student  already exists!");

        Student storage s = students[_studentAddress];
        s.studentAddress = _studentAddress;
        s.departmentId = _departmentId;
        s.studentCode = _studentCode;
        s.studentName = _studentName;
        s.enrolledCourses = new uint[](0);
        studentIdtoAddress[_studentCode] = _studentAddress;
    }
    function _addTeacher(address _teacherAddress,uint _teacherCode, string memory _name)public onlyOwner{
        //check if the teacher exists
        require(teacherIdtoAddress[_teacherCode] == address(0), "Teacher  already exists!");
        teachers[_teacherAddress] = TeachingStaff(_teacherAddress, _teacherCode, _name,new uint[](0));    
        teacherIdtoAddress[_teacherCode] = _teacherAddress;

    }
    function _assignCoursesToStudent(uint _studentCode, uint _courseCode) public onlyOwner{
        address studentAddress = studentIdtoAddress[_studentCode];

        //check if the course  exist
        require(courses[_courseCode].courseCode == _courseCode, "Course not found!");

        //check if the student exists
        require(studentIdtoAddress[_studentCode] != address(0), "Student  not found!");

        
        string memory courseName = courses[_courseCode].courseName;
        uint  departmentCode = courses[_courseCode].departmentCode;
        studentCourses[studentAddress][_courseCode] = Course(_courseCode, departmentCode, courseName);
        students[studentAddress].enrolledCourses.push(_courseCode);
        
    }


    function _assignCoursesToTeacher(uint _teacherCode, uint _courseCode) public onlyOwner{
        address teacherAddress = teacherIdtoAddress[_teacherCode];
    
        //check if the course  exist
        require(courses[_courseCode].courseCode == _courseCode, "Course not found!");
        
        //check if teacher exists
        require(teacherIdtoAddress[_teacherCode] != address(0), "Teacher  not found!");

        //check if teacher is already authorized !!
        require(!teacherCourses[teacherAddress][_courseCode], "Teacher already authorized for this course!");

        teacherCourses[teacherAddress][_courseCode] = true;
        teachers[teacherAddress].givenCourses.push(_courseCode);
        
    }

    //external Functions
    function _giveMark(address _teacherAddress, uint _studentCode, uint _courseCode, uint _givenMark) external returns(uint){
        address teacherAddress = _teacherAddress;
        //check if teacher is authorized to give mark
        require(teacherCourses[teacherAddress][_courseCode], "You are not authorized for this course!");

        //check if student exist
        require(studentIdtoAddress[_studentCode] != address(0), "Student does not exist");

        address studentAddress = studentIdtoAddress[_studentCode];

        //check if student has the course
        require(studentCourses[studentAddress][_courseCode].courseCode == _courseCode, "Student does not have that course!"); 
       
        Student storage s = students[studentAddress];
      
        s.studentCourseMarks[_courseCode] = Mark({courseCode: _courseCode, givenMark: _givenMark});

        s.studentMarks.push(s.studentCourseMarks[_courseCode]); // add given mark to the mark array
        
        return s.studentCourseMarks[_courseCode].givenMark;
    }
    function _getMyMarks(address _studentAddress, uint _courseCode)external view returns(uint){
        address studentAddress = _studentAddress;
        Student storage s = students[studentAddress];
        uint theMark = s.studentCourseMarks[_courseCode].givenMark;
        return theMark;
    }    

    function _getMyCourses(address _studentAddress) external view returns (string[] memory) {
        address studentAddress = _studentAddress;
        require(students[studentAddress].enrolledCourses.length > 0, "There is not any enrolled course!");
        uint[] memory enCourses = (students[studentAddress]).enrolledCourses;
        string[] memory result = new string[](enCourses.length);
        for(uint i = 0; i < enCourses.length; i++){
            uint id = enCourses[i];
            Course memory current = courses[id];
            result[i] = current.courseName;
        }
        return result;
       
    }

}