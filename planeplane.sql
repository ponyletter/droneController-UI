-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主机： 81.69.190.161:3306
-- 生成日期： 2025-12-25 13:14:26
-- 服务器版本： 8.0.42
-- PHP 版本： 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `planeplane`
--

-- --------------------------------------------------------

--
-- 表的结构 `t_alert_log`
--

CREATE TABLE `t_alert_log` (
  `id` int NOT NULL COMMENT '告警ID',
  `drone_id` int NOT NULL COMMENT '无人机ID',
  `alert_type` varchar(50) NOT NULL COMMENT '告警类型: low_battery/signal_lost/obstacle等',
  `alert_level` varchar(20) DEFAULT 'warning' COMMENT '告警级别: info/warning/error/critical',
  `alert_message` text COMMENT '告警信息',
  `is_handled` tinyint(1) DEFAULT '0' COMMENT '是否已处理: 0-未处理, 1-已处理',
  `handle_time` datetime DEFAULT NULL COMMENT '处理时间',
  `handler_id` int DEFAULT NULL COMMENT '处理人ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='告警记录表';

-- --------------------------------------------------------

--
-- 表的结构 `t_drone`
--

CREATE TABLE `t_drone` (
  `id` int NOT NULL COMMENT '无人机ID',
  `drone_name` varchar(100) NOT NULL COMMENT '无人机名称',
  `drone_model` varchar(50) DEFAULT NULL COMMENT '无人机型号',
  `serial_number` varchar(100) DEFAULT NULL COMMENT '序列号',
  `status` varchar(20) DEFAULT 'offline' COMMENT '状态: online/offline/flying/charging',
  `battery_level` decimal(5,2) DEFAULT '100.00' COMMENT '电池电量(%)',
  `gps_latitude` decimal(10,7) DEFAULT NULL COMMENT 'GPS纬度',
  `gps_longitude` decimal(10,7) DEFAULT NULL COMMENT 'GPS经度',
  `altitude` decimal(10,2) DEFAULT '0.00' COMMENT '海拔高度(米)',
  `speed` decimal(10,2) DEFAULT '0.00' COMMENT '速度(m/s)',
  `last_connect_time` datetime DEFAULT NULL COMMENT '最后连接时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='无人机信息表';

--
-- 转存表中的数据 `t_drone`
--

INSERT INTO `t_drone` (`id`, `drone_name`, `drone_model`, `serial_number`, `status`, `battery_level`, `gps_latitude`, `gps_longitude`, `altitude`, `speed`, `last_connect_time`, `create_time`, `update_time`) VALUES
(1, '无人机-001', 'DJI-Mavic', 'SN20241001', 'offline', 85.50, NULL, NULL, 0.00, 0.00, NULL, '2025-12-25 21:10:03', '2025-12-25 21:10:03'),
(2, '无人机-002', 'DJI-Phantom', 'SN20241002', 'offline', 92.30, NULL, NULL, 0.00, 0.00, NULL, '2025-12-25 21:10:03', '2025-12-25 21:10:03');

-- --------------------------------------------------------

--
-- 表的结构 `t_face_recognition`
--

CREATE TABLE `t_face_recognition` (
  `id` int NOT NULL COMMENT '记录ID',
  `face_name` varchar(100) NOT NULL COMMENT '人脸姓名',
  `face_image_path` varchar(255) DEFAULT NULL COMMENT '人脸图片路径',
  `confidence` decimal(5,2) DEFAULT NULL COMMENT '识别置信度',
  `recognition_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '识别时间',
  `drone_id` int DEFAULT NULL COMMENT '无人机ID',
  `location` varchar(255) DEFAULT NULL COMMENT '识别地点',
  `remarks` text COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='人脸识别记录表';

-- --------------------------------------------------------

--
-- 表的结构 `t_flight_log`
--

CREATE TABLE `t_flight_log` (
  `id` int NOT NULL COMMENT '日志ID',
  `drone_id` int NOT NULL COMMENT '无人机ID',
  `user_id` int NOT NULL COMMENT '操作用户ID',
  `flight_start_time` datetime DEFAULT NULL COMMENT '起飞时间',
  `flight_end_time` datetime DEFAULT NULL COMMENT '降落时间',
  `flight_duration` int DEFAULT '0' COMMENT '飞行时长(秒)',
  `max_altitude` decimal(10,2) DEFAULT '0.00' COMMENT '最大高度(米)',
  `max_speed` decimal(10,2) DEFAULT '0.00' COMMENT '最大速度(m/s)',
  `distance` decimal(10,2) DEFAULT '0.00' COMMENT '飞行距离(米)',
  `battery_used` decimal(5,2) DEFAULT '0.00' COMMENT '电池消耗(%)',
  `video_path` varchar(255) DEFAULT NULL COMMENT '视频保存路径',
  `status` varchar(20) DEFAULT 'completed' COMMENT '状态: completed/interrupted/error',
  `remarks` text COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='飞行日志表';

-- --------------------------------------------------------

--
-- 表的结构 `t_flight_track`
--

CREATE TABLE `t_flight_track` (
  `id` bigint NOT NULL COMMENT '轨迹点ID',
  `flight_log_id` int NOT NULL COMMENT '飞行日志ID',
  `timestamp` datetime NOT NULL COMMENT '时间戳',
  `latitude` decimal(10,7) NOT NULL COMMENT '纬度',
  `longitude` decimal(10,7) NOT NULL COMMENT '经度',
  `altitude` decimal(10,2) DEFAULT '0.00' COMMENT '高度(米)',
  `speed` decimal(10,2) DEFAULT '0.00' COMMENT '速度(m/s)',
  `heading` decimal(5,2) DEFAULT '0.00' COMMENT '航向角(度)',
  `battery_level` decimal(5,2) DEFAULT NULL COMMENT '电池电量(%)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='飞行轨迹数据表';

-- --------------------------------------------------------

--
-- 表的结构 `t_object_tracking`
--

CREATE TABLE `t_object_tracking` (
  `id` bigint NOT NULL COMMENT '跟踪ID',
  `drone_id` int NOT NULL COMMENT '无人机ID',
  `object_type` varchar(50) DEFAULT NULL COMMENT '目标类型: person/vehicle/animal等',
  `object_id` varchar(50) DEFAULT NULL COMMENT '目标编号',
  `detection_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '检测时间',
  `confidence` decimal(5,2) DEFAULT NULL COMMENT '置信度',
  `bbox_x` int DEFAULT NULL COMMENT '边界框X坐标',
  `bbox_y` int DEFAULT NULL COMMENT '边界框Y坐标',
  `bbox_width` int DEFAULT NULL COMMENT '边界框宽度',
  `bbox_height` int DEFAULT NULL COMMENT '边界框高度',
  `image_path` varchar(255) DEFAULT NULL COMMENT '截图路径',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='目标检测跟踪表';

-- --------------------------------------------------------

--
-- 表的结构 `t_statistics`
--

CREATE TABLE `t_statistics` (
  `id` int NOT NULL COMMENT '统计ID',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `total_flights` int DEFAULT '0' COMMENT '总飞行次数',
  `total_flight_time` int DEFAULT '0' COMMENT '总飞行时间(秒)',
  `total_distance` decimal(10,2) DEFAULT '0.00' COMMENT '总飞行距离(米)',
  `active_drones` int DEFAULT '0' COMMENT '活跃无人机数量',
  `total_alerts` int DEFAULT '0' COMMENT '总告警数量',
  `face_detections` int DEFAULT '0' COMMENT '人脸识别次数',
  `object_detections` int DEFAULT '0' COMMENT '目标检测次数',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据分析统计表';

-- --------------------------------------------------------

--
-- 表的结构 `t_system_config`
--

CREATE TABLE `t_system_config` (
  `id` int NOT NULL COMMENT '配置ID',
  `config_key` varchar(100) NOT NULL COMMENT '配置键',
  `config_value` text COMMENT '配置值',
  `config_desc` varchar(255) DEFAULT NULL COMMENT '配置描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统配置表';

--
-- 转存表中的数据 `t_system_config`
--

INSERT INTO `t_system_config` (`id`, `config_key`, `config_value`, `config_desc`, `create_time`, `update_time`) VALUES
(1, 'video_save_path', './output/', '视频保存路径', '2025-12-25 21:10:03', '2025-12-25 21:10:03'),
(2, 'image_save_path', './img/', '图片保存路径', '2025-12-25 21:10:03', '2025-12-25 21:10:03'),
(3, 'face_dataset_path', './face_dataset/', '人脸数据集路径', '2025-12-25 21:10:03', '2025-12-25 21:10:03'),
(4, 'max_flight_altitude', '120', '最大飞行高度(米)', '2025-12-25 21:10:03', '2025-12-25 21:10:03'),
(5, 'max_flight_speed', '15', '最大飞行速度(m/s)', '2025-12-25 21:10:03', '2025-12-25 21:10:03'),
(6, 'low_battery_warning', '20', '低电量警告阈值(%)', '2025-12-25 21:10:03', '2025-12-25 21:10:03'),
(7, 'auto_return_battery', '10', '自动返航电量阈值(%)', '2025-12-25 21:10:03', '2025-12-25 21:10:03');

-- --------------------------------------------------------

--
-- 表的结构 `t_user`
--

CREATE TABLE `t_user` (
  `id` int NOT NULL COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `role` varchar(20) DEFAULT 'user' COMMENT '角色: admin/user',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态: 0-禁用, 1-启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';

--
-- 转存表中的数据 `t_user`
--

INSERT INTO `t_user` (`id`, `username`, `password`, `real_name`, `email`, `phone`, `role`, `status`, `create_time`, `update_time`) VALUES
(1, 'admin', 'admin123', '管理员', 'admin@example.com', NULL, 'admin', 1, '2025-12-25 21:10:03', '2025-12-25 21:10:03'),
(2, 'user1', '123456', '测试用户', 'user1@example.com', NULL, 'user', 1, '2025-12-25 21:10:03', '2025-12-25 21:10:03'),
(3, 'sugar', 'sugar', NULL, NULL, NULL, 'user', 1, '2025-12-25 21:10:47', '2025-12-25 21:10:47');

-- --------------------------------------------------------

--
-- 表的结构 `t_video_file`
--

CREATE TABLE `t_video_file` (
  `id` int NOT NULL COMMENT '视频ID',
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_path` varchar(500) NOT NULL COMMENT '文件路径',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小(字节)',
  `duration` int DEFAULT NULL COMMENT '视频时长(秒)',
  `resolution` varchar(20) DEFAULT NULL COMMENT '分辨率',
  `drone_id` int DEFAULT NULL COMMENT '无人机ID',
  `flight_log_id` int DEFAULT NULL COMMENT '飞行日志ID',
  `upload_user_id` int DEFAULT NULL COMMENT '上传用户ID',
  `description` text COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='视频文件表';

--
-- 转储表的索引
--

--
-- 表的索引 `t_alert_log`
--
ALTER TABLE `t_alert_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_drone_id` (`drone_id`),
  ADD KEY `idx_alert_type` (`alert_type`),
  ADD KEY `idx_is_handled` (`is_handled`),
  ADD KEY `idx_create_time` (`create_time`),
  ADD KEY `fk_alert_handler` (`handler_id`);

--
-- 表的索引 `t_drone`
--
ALTER TABLE `t_drone`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_serial_number` (`serial_number`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `t_face_recognition`
--
ALTER TABLE `t_face_recognition`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_drone_id` (`drone_id`),
  ADD KEY `idx_recognition_time` (`recognition_time`);

--
-- 表的索引 `t_flight_log`
--
ALTER TABLE `t_flight_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_drone_id` (`drone_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_flight_time` (`flight_start_time`);

--
-- 表的索引 `t_flight_track`
--
ALTER TABLE `t_flight_track`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_flight_log_id` (`flight_log_id`),
  ADD KEY `idx_timestamp` (`timestamp`);

--
-- 表的索引 `t_object_tracking`
--
ALTER TABLE `t_object_tracking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_drone_id` (`drone_id`),
  ADD KEY `idx_object_type` (`object_type`),
  ADD KEY `idx_detection_time` (`detection_time`);

--
-- 表的索引 `t_statistics`
--
ALTER TABLE `t_statistics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_stat_date` (`stat_date`);

--
-- 表的索引 `t_system_config`
--
ALTER TABLE `t_system_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_config_key` (`config_key`);

--
-- 表的索引 `t_user`
--
ALTER TABLE `t_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_username` (`username`),
  ADD KEY `idx_email` (`email`);

--
-- 表的索引 `t_video_file`
--
ALTER TABLE `t_video_file`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_drone_id` (`drone_id`),
  ADD KEY `idx_flight_log_id` (`flight_log_id`),
  ADD KEY `idx_create_time` (`create_time`),
  ADD KEY `fk_video_user` (`upload_user_id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `t_alert_log`
--
ALTER TABLE `t_alert_log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT '告警ID';

--
-- 使用表AUTO_INCREMENT `t_drone`
--
ALTER TABLE `t_drone`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT '无人机ID', AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `t_face_recognition`
--
ALTER TABLE `t_face_recognition`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT '记录ID';

--
-- 使用表AUTO_INCREMENT `t_flight_log`
--
ALTER TABLE `t_flight_log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT '日志ID';

--
-- 使用表AUTO_INCREMENT `t_flight_track`
--
ALTER TABLE `t_flight_track`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '轨迹点ID';

--
-- 使用表AUTO_INCREMENT `t_object_tracking`
--
ALTER TABLE `t_object_tracking`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '跟踪ID';

--
-- 使用表AUTO_INCREMENT `t_statistics`
--
ALTER TABLE `t_statistics`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT '统计ID';

--
-- 使用表AUTO_INCREMENT `t_system_config`
--
ALTER TABLE `t_system_config`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT '配置ID', AUTO_INCREMENT=8;

--
-- 使用表AUTO_INCREMENT `t_user`
--
ALTER TABLE `t_user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID', AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `t_video_file`
--
ALTER TABLE `t_video_file`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT '视频ID';

--
-- 限制导出的表
--

--
-- 限制表 `t_alert_log`
--
ALTER TABLE `t_alert_log`
  ADD CONSTRAINT `fk_alert_drone` FOREIGN KEY (`drone_id`) REFERENCES `t_drone` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_alert_handler` FOREIGN KEY (`handler_id`) REFERENCES `t_user` (`id`) ON DELETE SET NULL;

--
-- 限制表 `t_flight_log`
--
ALTER TABLE `t_flight_log`
  ADD CONSTRAINT `fk_flight_drone` FOREIGN KEY (`drone_id`) REFERENCES `t_drone` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_flight_user` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`id`) ON DELETE CASCADE;

--
-- 限制表 `t_flight_track`
--
ALTER TABLE `t_flight_track`
  ADD CONSTRAINT `fk_track_flight` FOREIGN KEY (`flight_log_id`) REFERENCES `t_flight_log` (`id`) ON DELETE CASCADE;

--
-- 限制表 `t_video_file`
--
ALTER TABLE `t_video_file`
  ADD CONSTRAINT `fk_video_drone` FOREIGN KEY (`drone_id`) REFERENCES `t_drone` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_video_flight` FOREIGN KEY (`flight_log_id`) REFERENCES `t_flight_log` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_video_user` FOREIGN KEY (`upload_user_id`) REFERENCES `t_user` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
