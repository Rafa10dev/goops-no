/*
  Warnings:

  - The values [USER] on the enum `UserRole` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `updatedAt` on the `Chip` table. All the data in the column will be lost.
  - Added the required column `status` to the `Chip` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "ChipStatus" AS ENUM ('ACTIVATED', 'DEFECTIVE');

-- CreateEnum
CREATE TYPE "ConnectionStatus" AS ENUM ('ALLOCATED', 'RECONNECTED', 'RESTRICTED', 'BANNED');

-- AlterEnum
BEGIN;
CREATE TYPE "UserRole_new" AS ENUM ('OPERATOR', 'ADMIN');
ALTER TABLE "public"."User" ALTER COLUMN "role" DROP DEFAULT;
ALTER TABLE "User" ALTER COLUMN "role" TYPE "UserRole_new" USING ("role"::text::"UserRole_new");
ALTER TYPE "UserRole" RENAME TO "UserRole_old";
ALTER TYPE "UserRole_new" RENAME TO "UserRole";
DROP TYPE "public"."UserRole_old";
ALTER TABLE "User" ALTER COLUMN "role" SET DEFAULT 'OPERATOR';
COMMIT;

-- AlterTable
ALTER TABLE "Chip" DROP COLUMN "updatedAt",
ADD COLUMN     "status" "ChipStatus" NOT NULL;

-- AlterTable
ALTER TABLE "User" ALTER COLUMN "role" SET DEFAULT 'OPERATOR';

-- CreateTable
CREATE TABLE "Company" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Url" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "companyId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Url_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserUrl" (
    "userId" INTEGER NOT NULL,
    "urlId" INTEGER NOT NULL,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserUrl_pkey" PRIMARY KEY ("userId","urlId")
);

-- CreateTable
CREATE TABLE "Cellphone" (
    "id" SERIAL NOT NULL,
    "name" TEXT,
    "model" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Cellphone_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CellphoneSlot" (
    "id" SERIAL NOT NULL,
    "cellphoneId" INTEGER NOT NULL,
    "slotNumber" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CellphoneSlot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Connection" (
    "id" SERIAL NOT NULL,
    "status" "ConnectionStatus" NOT NULL DEFAULT 'ALLOCATED',
    "phoneNumberId" TEXT NOT NULL,
    "cellphoneSlotId" INTEGER NOT NULL,
    "companyId" INTEGER NOT NULL,
    "urlId" INTEGER NOT NULL,
    "createdById" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Connection_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Url_companyId_name_key" ON "Url"("companyId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Url_companyId_url_key" ON "Url"("companyId", "url");

-- CreateIndex
CREATE UNIQUE INDEX "CellphoneSlot_cellphoneId_slotNumber_key" ON "CellphoneSlot"("cellphoneId", "slotNumber");

-- AddForeignKey
ALTER TABLE "Url" ADD CONSTRAINT "Url_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserUrl" ADD CONSTRAINT "UserUrl_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserUrl" ADD CONSTRAINT "UserUrl_urlId_fkey" FOREIGN KEY ("urlId") REFERENCES "Url"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CellphoneSlot" ADD CONSTRAINT "CellphoneSlot_cellphoneId_fkey" FOREIGN KEY ("cellphoneId") REFERENCES "Cellphone"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Connection" ADD CONSTRAINT "Connection_phoneNumberId_fkey" FOREIGN KEY ("phoneNumberId") REFERENCES "PhoneNumber"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Connection" ADD CONSTRAINT "Connection_cellphoneSlotId_fkey" FOREIGN KEY ("cellphoneSlotId") REFERENCES "CellphoneSlot"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Connection" ADD CONSTRAINT "Connection_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Connection" ADD CONSTRAINT "Connection_urlId_fkey" FOREIGN KEY ("urlId") REFERENCES "Url"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Connection" ADD CONSTRAINT "Connection_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
