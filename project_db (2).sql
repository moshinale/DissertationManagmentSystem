-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 04, 2025 at 10:57 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `project_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `DepartmentID` int(11) NOT NULL,
  `DepartmentName` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`DepartmentID`, `DepartmentName`) VALUES
(17, 'Accounting and Finance'),
(7, 'Aerospace Engineering'),
(20, 'Artificial Intelligence'),
(26, 'Aviation Management'),
(8, 'Avionics Engineering'),
(6, 'Bio Medical Engineering'),
(11, 'Business Administration (BBA)'),
(30, 'Business Analytics'),
(5, 'Computer Engineering'),
(18, 'Computer Games Design'),
(13, 'Computer Science'),
(1, 'Cyber Security'),
(21, 'Data Science'),
(25, 'Education'),
(2, 'Electrical Engineering (Power/Electronics/Telecom)'),
(15, 'English'),
(27, 'Health Care Management'),
(10, 'Information Security'),
(19, 'Information Technology'),
(31, 'International Relations (I.R)'),
(16, 'Management Sciences'),
(14, 'Mathematics'),
(32, 'MBBS'),
(4, 'Mechanical Engineering'),
(3, 'Mechatronics Engineering'),
(12, 'Physics'),
(29, 'Project Management'),
(24, 'Psychology'),
(22, 'Software Engineering'),
(23, 'Strategic Studies'),
(9, 'System Security'),
(28, 'Tourism and Hospitality Management');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `FeedbackID` int(11) NOT NULL,
  `ProjectID` int(11) DEFAULT NULL,
  `SenderID` int(11) DEFAULT NULL,
  `ReceiverID` int(11) DEFAULT NULL,
  `FeedbackText` text DEFAULT NULL,
  `FeedbackFilePath` varchar(255) DEFAULT NULL,
  `Rating` int(11) DEFAULT NULL,
  `IsRead` tinyint(1) DEFAULT 0,
  `SentAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `SubmissionID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--


-- --------------------------------------------------------

--
-- Table structure for table `fileuploads`
--

CREATE TABLE `fileuploads` (
  `FileID` int(11) NOT NULL,
  `FileName` varchar(255) NOT NULL,
  `FilePath` varchar(255) NOT NULL,
  `FileType` varchar(100) NOT NULL,
  `FileSize` int(11) NOT NULL,
  `UploadedBy` int(11) NOT NULL,
  `SubmissionID` int(11) DEFAULT NULL,
  `UploadedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fileuploads`
--


-- --------------------------------------------------------

--
-- Table structure for table `geminiconversations`
--

CREATE TABLE `geminiconversations` (
  `ConversationID` int(11) NOT NULL,
  `SupervisorID` int(11) NOT NULL,
  `Topic` varchar(255) DEFAULT NULL,
  `LastUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `geminimessages`
--

CREATE TABLE `geminimessages` (
  `MessageID` int(11) NOT NULL,
  `ConversationID` int(11) NOT NULL,
  `IsUserMessage` tinyint(1) DEFAULT 1,
  `Content` text DEFAULT NULL,
  `SentAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `generatedprojects`
--

CREATE TABLE `generatedprojects` (
  `GeneratedProjectID` int(11) NOT NULL,
  `SupervisorID` int(11) NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Description` text DEFAULT NULL,
  `Objectives` text DEFAULT NULL,
  `TechnologyStack` text DEFAULT NULL,
  `Complexity` varchar(50) DEFAULT NULL,
  `GeneratedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `IsAssigned` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `groupfeedback`
--

CREATE TABLE `groupfeedback` (
  `FeedbackID` int(11) NOT NULL,
  `GroupID` int(11) NOT NULL,
  `SenderID` int(11) NOT NULL,
  `FeedbackText` text NOT NULL,
  `FeedbackFilePath` varchar(255) DEFAULT NULL,
  `SentAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `groupfeedback`
--


-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE `groups` (
  `GroupID` int(11) NOT NULL,
  `GroupName` varchar(255) NOT NULL,
  `SupervisorID` int(11) NOT NULL,
  `Description` text DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `Status` enum('Active','Inactive') DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `groups`
--

--
-- Triggers `groups`
--
DELIMITER $$
CREATE TRIGGER `after_group_delete` AFTER DELETE ON `groups` FOR EACH ROW BEGIN
    UPDATE Users SET GroupCount = GroupCount - 1 WHERE UserID = OLD.SupervisorID;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_group_insert` AFTER INSERT ON `groups` FOR EACH ROW BEGIN
    UPDATE Users SET GroupCount = GroupCount + 1 WHERE UserID = NEW.SupervisorID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `milestones`
--

CREATE TABLE `milestones` (
  `MilestoneID` int(11) NOT NULL,
  `ProjectID` int(11) DEFAULT NULL,
  `MilestoneTitle` varchar(50) DEFAULT NULL,
  `DueDate` date DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `UpdatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Description` text DEFAULT NULL,
  `MaxMarks` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `milestones`
--

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `NotificationID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Message` text NOT NULL,
  `IsRead` tinyint(1) DEFAULT 0,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

-- --------------------------------------------------------

--
-- Table structure for table `pdfanalysis`
--

CREATE TABLE `pdfanalysis` (
  `AnalysisID` int(11) NOT NULL,
  `SupervisorID` int(11) NOT NULL,
  `FileName` varchar(255) NOT NULL,
  `FilePath` varchar(255) NOT NULL,
  `Summary` text DEFAULT NULL,
  `AnalyzedAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pdfanalysis`
--


-- --------------------------------------------------------

--
-- Table structure for table `profile`
--

CREATE TABLE `profile` (
  `ProfileID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `FirstName` varchar(100) DEFAULT NULL,
  `LastName` varchar(100) DEFAULT NULL,
  `ContactInfo` varchar(100) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `CNIC` varchar(20) DEFAULT NULL,
  `ProfileImage` varchar(255) DEFAULT 'https://via.placeholder.com/250',
  `gender` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `profile`
--

-- --------------------------------------------------------

--
-- Table structure for table `projecthistory`
--

CREATE TABLE `projecthistory` (
  `HistoryID` int(11) NOT NULL,
  `ProjectID` int(11) DEFAULT NULL,
  `Action` varchar(255) DEFAULT NULL,
  `ActionDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `UserID` int(11) DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `DaysLate` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `projecthistory`
--


-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `ProjectID` int(11) NOT NULL,
  `Title` varchar(255) NOT NULL,
  `Description` text DEFAULT NULL,
  `Objectives` text DEFAULT NULL,
  `SupervisorID` int(11) DEFAULT NULL,
  `StudentID` int(11) DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `UpdatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `GroupID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `projects`
--


-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `RoleID` int(11) NOT NULL,
  `RoleName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`RoleID`, `RoleName`) VALUES
(1, 'Admin'),
(3, 'Student'),
(2, 'Supervisor');

-- --------------------------------------------------------

--
-- Table structure for table `studentgroups`
--

CREATE TABLE `studentgroups` (
  `StudentGroupID` int(11) NOT NULL,
  `GroupID` int(11) NOT NULL,
  `StudentID` int(11) NOT NULL,
  `JoinedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `Status` enum('Active','Inactive') DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



CREATE TABLE `submissions` (
  `SubmissionID` int(11) NOT NULL,
  `ProjectID` int(11) DEFAULT NULL,
  `SubmissionType` varchar(50) DEFAULT NULL,
  `Version` int(11) DEFAULT 1,
  `FilePath` varchar(255) DEFAULT NULL,
  `SubmittedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `MilestoneID` int(11) DEFAULT NULL,
  `Remarks` text DEFAULT 'No remarks provided',
  `Status` varchar(50) DEFAULT NULL,
  `ReviewStatus` enum('Pending','Accepted','Rejected') DEFAULT 'Pending',
  `ReviewedBy` int(11) DEFAULT NULL,
  `ReviewedAt` timestamp NULL DEFAULT NULL,
  `ObtainedMarks` int(11) DEFAULT NULL,
  `Marks` decimal(5,2) DEFAULT NULL,
  `MaxMarks` decimal(5,2) DEFAULT 100.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `submissions`
--


-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UserID` int(11) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `StudentID` varchar(20) DEFAULT NULL,
  `DepartmentID` int(11) DEFAULT NULL,
  `RoleID` int(11) DEFAULT NULL,
  `StatusID` int(11) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `UpdatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `GroupCount` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserID`, `Username`, `Email`, `PasswordHash`, `StudentID`, `DepartmentID`, `RoleID`, `StatusID`, `CreatedAt`, `UpdatedAt`, `GroupCount`) VALUES
(1, 'admin@aiu.com', 'admin@aiu.com', '$2y$10$zCI/GXkKvwjEWmsjjzHmYeiP5.kDIXxYF64AefHkYUlF/4KhJ5vpa', NULL, NULL, 1, 5, '2024-12-04 12:25:39', '2024-12-04 12:25:39', 0);

-- --------------------------------------------------------

--
-- Table structure for table `userstatus`
--

CREATE TABLE `userstatus` (
  `StatusID` int(11) NOT NULL,
  `StatusName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `userstatus`
--

INSERT INTO `userstatus` (`StatusID`, `StatusName`) VALUES
(5, 'Active'),
(2, 'Approved'),
(4, 'Blocked'),
(1, 'Pending'),
(3, 'Rejected');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`DepartmentID`),
  ADD UNIQUE KEY `DepartmentName` (`DepartmentName`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`FeedbackID`),
  ADD KEY `ProjectID` (`ProjectID`),
  ADD KEY `SenderID` (`SenderID`),
  ADD KEY `ReceiverID` (`ReceiverID`),
  ADD KEY `SubmissionID` (`SubmissionID`);

--
-- Indexes for table `fileuploads`
--
ALTER TABLE `fileuploads`
  ADD PRIMARY KEY (`FileID`),
  ADD KEY `UploadedBy` (`UploadedBy`),
  ADD KEY `SubmissionID` (`SubmissionID`);

--
-- Indexes for table `geminiconversations`
--
ALTER TABLE `geminiconversations`
  ADD PRIMARY KEY (`ConversationID`),
  ADD KEY `SupervisorID` (`SupervisorID`);

--
-- Indexes for table `geminimessages`
--
ALTER TABLE `geminimessages`
  ADD PRIMARY KEY (`MessageID`),
  ADD KEY `ConversationID` (`ConversationID`);

--
-- Indexes for table `generatedprojects`
--
ALTER TABLE `generatedprojects`
  ADD PRIMARY KEY (`GeneratedProjectID`),
  ADD KEY `SupervisorID` (`SupervisorID`);

--
-- Indexes for table `groupfeedback`
--
ALTER TABLE `groupfeedback`
  ADD PRIMARY KEY (`FeedbackID`),
  ADD KEY `SenderID` (`SenderID`),
  ADD KEY `idx_groupfeedback_group` (`GroupID`);

--
-- Indexes for table `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`GroupID`),
  ADD KEY `idx_groups_supervisor` (`SupervisorID`);

--
-- Indexes for table `milestones`
--
ALTER TABLE `milestones`
  ADD PRIMARY KEY (`MilestoneID`),
  ADD KEY `ProjectID` (`ProjectID`),
  ADD KEY `idx_milestones_maxmarks` (`MaxMarks`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`NotificationID`),
  ADD KEY `idx_notifications_user` (`UserID`);

--
-- Indexes for table `pdfanalysis`
--
ALTER TABLE `pdfanalysis`
  ADD PRIMARY KEY (`AnalysisID`),
  ADD KEY `SupervisorID` (`SupervisorID`);

--
-- Indexes for table `profile`
--
ALTER TABLE `profile`
  ADD PRIMARY KEY (`ProfileID`),
  ADD UNIQUE KEY `CNIC` (`CNIC`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `projecthistory`
--
ALTER TABLE `projecthistory`
  ADD PRIMARY KEY (`HistoryID`),
  ADD KEY `ProjectID` (`ProjectID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`ProjectID`),
  ADD KEY `SupervisorID` (`SupervisorID`),
  ADD KEY `StudentID` (`StudentID`),
  ADD KEY `idx_projects_group` (`GroupID`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`RoleID`),
  ADD UNIQUE KEY `RoleName` (`RoleName`);

--
-- Indexes for table `studentgroups`
--
ALTER TABLE `studentgroups`
  ADD PRIMARY KEY (`StudentGroupID`),
  ADD UNIQUE KEY `GroupID` (`GroupID`,`StudentID`),
  ADD KEY `idx_studentgroups_group` (`GroupID`),
  ADD KEY `idx_studentgroups_student` (`StudentID`);

--
-- Indexes for table `submissions`
--
ALTER TABLE `submissions`
  ADD PRIMARY KEY (`SubmissionID`),
  ADD KEY `ProjectID` (`ProjectID`),
  ADD KEY `MilestoneID` (`MilestoneID`),
  ADD KEY `ReviewedBy` (`ReviewedBy`),
  ADD KEY `idx_submissions_review` (`ReviewStatus`),
  ADD KEY `idx_submissions_marks` (`Marks`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `StudentID` (`StudentID`),
  ADD KEY `DepartmentID` (`DepartmentID`),
  ADD KEY `RoleID` (`RoleID`),
  ADD KEY `StatusID` (`StatusID`);

--
-- Indexes for table `userstatus`
--
ALTER TABLE `userstatus`
  ADD PRIMARY KEY (`StatusID`),
  ADD UNIQUE KEY `StatusName` (`StatusName`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `DepartmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `FeedbackID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `fileuploads`
--
ALTER TABLE `fileuploads`
  MODIFY `FileID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `geminiconversations`
--
ALTER TABLE `geminiconversations`
  MODIFY `ConversationID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `geminimessages`
--
ALTER TABLE `geminimessages`
  MODIFY `MessageID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `generatedprojects`
--
ALTER TABLE `generatedprojects`
  MODIFY `GeneratedProjectID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `groupfeedback`
--
ALTER TABLE `groupfeedback`
  MODIFY `FeedbackID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `groups`
--
ALTER TABLE `groups`
  MODIFY `GroupID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `milestones`
--
ALTER TABLE `milestones`
  MODIFY `MilestoneID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `NotificationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `pdfanalysis`
--
ALTER TABLE `pdfanalysis`
  MODIFY `AnalysisID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `profile`
--
ALTER TABLE `profile`
  MODIFY `ProfileID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `projecthistory`
--
ALTER TABLE `projecthistory`
  MODIFY `HistoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `ProjectID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `RoleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `studentgroups`
--
ALTER TABLE `studentgroups`
  MODIFY `StudentGroupID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `submissions`
--
ALTER TABLE `submissions`
  MODIFY `SubmissionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `userstatus`
--
ALTER TABLE `userstatus`
  MODIFY `StatusID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`ProjectID`) REFERENCES `projects` (`ProjectID`),
  ADD CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`SenderID`) REFERENCES `users` (`UserID`),
  ADD CONSTRAINT `feedback_ibfk_3` FOREIGN KEY (`ReceiverID`) REFERENCES `users` (`UserID`),
  ADD CONSTRAINT `feedback_ibfk_4` FOREIGN KEY (`SubmissionID`) REFERENCES `submissions` (`SubmissionID`);

--
-- Constraints for table `fileuploads`
--
ALTER TABLE `fileuploads`
  ADD CONSTRAINT `fileuploads_ibfk_1` FOREIGN KEY (`UploadedBy`) REFERENCES `users` (`UserID`),
  ADD CONSTRAINT `fileuploads_ibfk_2` FOREIGN KEY (`SubmissionID`) REFERENCES `submissions` (`SubmissionID`) ON DELETE CASCADE;

--
-- Constraints for table `geminiconversations`
--
ALTER TABLE `geminiconversations`
  ADD CONSTRAINT `geminiconversations_ibfk_1` FOREIGN KEY (`SupervisorID`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `geminimessages`
--
ALTER TABLE `geminimessages`
  ADD CONSTRAINT `geminimessages_ibfk_1` FOREIGN KEY (`ConversationID`) REFERENCES `geminiconversations` (`ConversationID`) ON DELETE CASCADE;

--
-- Constraints for table `generatedprojects`
--
ALTER TABLE `generatedprojects`
  ADD CONSTRAINT `generatedprojects_ibfk_1` FOREIGN KEY (`SupervisorID`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `groupfeedback`
--
ALTER TABLE `groupfeedback`
  ADD CONSTRAINT `groupfeedback_ibfk_1` FOREIGN KEY (`GroupID`) REFERENCES `groups` (`GroupID`) ON DELETE CASCADE,
  ADD CONSTRAINT `groupfeedback_ibfk_2` FOREIGN KEY (`SenderID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE;

--
-- Constraints for table `groups`
--
ALTER TABLE `groups`
  ADD CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`SupervisorID`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `milestones`
--
ALTER TABLE `milestones`
  ADD CONSTRAINT `milestones_ibfk_1` FOREIGN KEY (`ProjectID`) REFERENCES `projects` (`ProjectID`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE;

--
-- Constraints for table `pdfanalysis`
--
ALTER TABLE `pdfanalysis`
  ADD CONSTRAINT `pdfanalysis_ibfk_1` FOREIGN KEY (`SupervisorID`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `profile`
--
ALTER TABLE `profile`
  ADD CONSTRAINT `profile_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE;

--
-- Constraints for table `projecthistory`
--
ALTER TABLE `projecthistory`
  ADD CONSTRAINT `projecthistory_ibfk_1` FOREIGN KEY (`ProjectID`) REFERENCES `projects` (`ProjectID`),
  ADD CONSTRAINT `projecthistory_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`SupervisorID`) REFERENCES `users` (`UserID`),
  ADD CONSTRAINT `projects_ibfk_2` FOREIGN KEY (`StudentID`) REFERENCES `users` (`UserID`),
  ADD CONSTRAINT `projects_ibfk_3` FOREIGN KEY (`GroupID`) REFERENCES `groups` (`GroupID`);

--
-- Constraints for table `studentgroups`
--
ALTER TABLE `studentgroups`
  ADD CONSTRAINT `studentgroups_ibfk_1` FOREIGN KEY (`GroupID`) REFERENCES `groups` (`GroupID`),
  ADD CONSTRAINT `studentgroups_ibfk_2` FOREIGN KEY (`StudentID`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `submissions`
--
ALTER TABLE `submissions`
  ADD CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`ProjectID`) REFERENCES `projects` (`ProjectID`),
  ADD CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`MilestoneID`) REFERENCES `milestones` (`MilestoneID`),
  ADD CONSTRAINT `submissions_ibfk_3` FOREIGN KEY (`ReviewedBy`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`DepartmentID`) REFERENCES `departments` (`DepartmentID`),
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`RoleID`) REFERENCES `roles` (`RoleID`),
  ADD CONSTRAINT `users_ibfk_3` FOREIGN KEY (`StatusID`) REFERENCES `userstatus` (`StatusID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
