CREATE TABLE `pessoas` (
  `id` varchar(255) NOT NULL,
  `nome` text NOT NULL,
  `apelido` varchar(255) NOT NULL,
  `stack` json NOT NULL,
  `nascimento` date NOT NULL,
  `serchable` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;