CREATE TABLE shared_outfits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    outfit_name VARCHAR(255) NOT NULL,
    outfit_data JSON NOT NULL,
    share_link VARCHAR(255) NOT NULL UNIQUE,
    creator_id VARCHAR(255) NOT NULL,
    creator_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE player_outfits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_identifier VARCHAR(255) NOT NULL,
    outfit_name VARCHAR(255) NOT NULL,
    outfit_data JSON NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE(player_identifier, outfit_name)
);
