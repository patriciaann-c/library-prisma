/*
  Warnings:

  - Added the required column `booksId` to the `Loans` table without a default value. This is not possible if the table is not empty.
  - Added the required column `membersId` to the `Loans` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `loans` ADD COLUMN `booksId` INTEGER NOT NULL,
    ADD COLUMN `membersId` INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE `Loans` ADD CONSTRAINT `Loans_booksId_fkey` FOREIGN KEY (`booksId`) REFERENCES `Books`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Loans` ADD CONSTRAINT `Loans_membersId_fkey` FOREIGN KEY (`membersId`) REFERENCES `Members`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
