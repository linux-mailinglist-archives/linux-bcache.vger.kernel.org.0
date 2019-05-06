Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9A9147AE
	for <lists+linux-bcache@lfdr.de>; Mon,  6 May 2019 11:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfEFJeY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 May 2019 05:34:24 -0400
Received: from m50-134.163.com ([123.125.50.134]:50427 "EHLO m50-134.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfEFJeX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 May 2019 05:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=JX24e
        ddmN0PysCwtZg5z+sThgVmDmhRG6yJDkDEK7h4=; b=DbTOzglTnRKPREL+3eZ0j
        GtU/zmV+Hu1yzd6Jq/KDzt6N2l7kj1wkDNkk983CR3mLXCBKdMU5ONZwyKOkSMC+
        4ZKr3LB4rx+ZI2uHVjjZgCmMbRjHNjQXPl2h+PB7Pf4Il7BQgqTBOtPKG7hmnfU/
        0m9XzPUjB9gZFUaJKzzQ9c=
Received: from localhost.localdomain (unknown [61.181.149.218])
        by smtp4 (Coremail) with SMTP id DtGowAAXunKQ_89cyWgBAQ--.153S4;
        Mon, 06 May 2019 17:34:19 +0800 (CST)
From:   Xinwei Wei <nkxiaowei@163.com>
To:     linux-bcache@vger.kernel.org
Cc:     weixinwei <nkxiaowei@163.com>
Subject: [PATCH 1/1] bcache-tools:Add blkdiscard if cache dev supports TRIM
Date:   Mon,  6 May 2019 17:33:46 +0800
Message-Id: <20190506093345.7780-1-nkxiaowei@163.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DtGowAAXunKQ_89cyWgBAQ--.153S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3KFWrKw18Kr1DWFWUJry7KFg_yoWkCryxpa
        4fWws5trZ8J3y7G393Jr15K3WSgwsYy342gF13Xa98Zay3Kr95WFWxCF1jqa4qgr43X3s3
        Xr1vv3WUGw4DtrJanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUpnQUUUUU=
X-Originating-IP: [61.181.149.218]
X-CM-SenderInfo: 5qn0xtprzhxqqrwthudrp/1tbiMBusyFWBms23bQAAsW
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: weixinwei <nkxiaowei@163.com>

Signed-off-by: Xinwei Wei <nkxiaowei@163.com>
---
 bcache.h |  86 ++++++++++++++++
 make.c   | 307 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 392 insertions(+), 1 deletion(-)

diff --git a/bcache.h b/bcache.h
index 61e4252..105979e 100644
--- a/bcache.h
+++ b/bcache.h
@@ -40,6 +40,92 @@ static const char bcache_magic[] = {
 #define BDEV_DATA_START_DEFAULT	16	/* sectors */
 #define SB_START		(SB_SECTOR * 512)
 
+
+#define ATA_OP_IDENTIFY		0xec
+#define ATA_OP_PIDENTIFY	0xa1
+
+/*
+ * Some useful ATA register bits
+ */
+enum {
+	ATA_USING_LBA		= (1 << 6),
+	ATA_STAT_DRQ		= (1 << 3),
+	ATA_STAT_ERR		= (1 << 0),
+};
+
+/*
+ * ATA PASS-THROUGH (16) CDB
+ */
+#define SG_ATA_16			0x85
+#define SG_ATA_16_LEN			16
+
+/*
+ * ATA Protocols
+ */
+#define SG_ATA_PROTO_PIO_IN		(4 << 1)	/* PIO Data-in */
+
+enum {
+	/* No data is transferred */
+	SG_CDB2_TLEN_NODATA	= 0 << 0,
+	/* Transfer Length is found in the Feature field */
+	SG_CDB2_TLEN_FEAT	= 1 << 0,
+	/* Transfer Length is found in the Sector Count field */
+	SG_CDB2_TLEN_NSECT	= 2 << 0,
+
+	/* transfer units for Transfer Length are bytes */
+	SG_CDB2_TLEN_BYTES	= 0 << 2,
+	/* transfer units for Transfer Length are blocks */
+	SG_CDB2_TLEN_SECTORS	= 1 << 2,
+
+	/* data is transferred from the initiator to the target */
+	SG_CDB2_TDIR_TO_DEV	= 0 << 3,
+	/* indicate that data is transferred from the target to the initiator */
+	SG_CDB2_TDIR_FROM_DEV	= 1 << 3,
+
+	/* Check Condition */
+	SG_CDB2_CHECK_COND	= 1 << 5,
+};
+
+/*
+ *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-6
+ *  T10/BSR INCITS 546 dated January 5, 2018.
+ */
+#define SAM_STAT_GOOD		0x00
+#define SG_CHECK_CONDITION	0x02
+#define SG_DRIVER_SENSE		0x08
+
+/*
+ * This is a slightly modified SCSI sense "descriptor" format header.
+ * The addition is to allow the 0x70 and 0x71 response codes. The idea
+ * is to place the salient data from either "fixed" or "descriptor" sense
+ * format into one structure to ease application processing.
+ *
+ * The original sense buffer should be kept around for those cases
+ * in which more information is required (e.g. the LBA of a MEDIUM ERROR).
+ */
+struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
+	uint8_t response_code;	/* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
+	uint8_t sense_key;
+	uint8_t asc;
+	uint8_t ascq;
+	uint8_t byte4;
+	uint8_t byte5;
+	uint8_t byte6;
+	uint8_t additional_length;	/* always 0 for fixed sense format */
+};
+
+/*
+ *  SENSE KEYS
+ */
+
+#define SG_NO_SENSE            0x00
+#define SG_RECOVERED_ERROR     0x01
+
+/* NVME Admin commands */
+#define nvme_admin_identify	0x06
+
+#define NVME_IDENTIFY_DATA_SIZE 4096
+
 struct cache_sb {
 	uint64_t		csum;
 	uint64_t		offset;	/* sector where this sb was written */
diff --git a/make.c b/make.c
index e5e7464..3a7badb 100644
--- a/make.c
+++ b/make.c
@@ -31,10 +31,16 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <uuid/uuid.h>
+#include <linux/hdreg.h>
+#include <asm/byteorder.h>
+#include <libgen.h>
 
 #include "bcache.h"
 #include "lib.h"
 
+#include <scsi/sg.h>
+#include <linux/nvme_ioctl.h>
+
 #define max(x, y) ({				\
 	typeof(x) _max1 = (x);			\
 	typeof(y) _max2 = (y);			\
@@ -179,6 +185,300 @@ const char * const cache_replacement_policies[] = {
 	NULL
 };
 
+int scsi_normalize_sense(const uint8_t *sense_buffer,
+		struct scsi_sense_hdr *sshdr)
+{
+	if (!sense_buffer)
+		goto err;
+
+	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
+
+	sshdr->response_code = (sense_buffer[0] & 0x7f);
+	if ((sshdr->response_code & 0x70) != 0x70)
+		goto err;
+
+	if (sshdr->response_code >= 0x72) {
+		/*
+		 * descriptor format
+		 */
+		sshdr->sense_key = (sense_buffer[1] & 0xf);
+		sshdr->asc = sense_buffer[2];
+		sshdr->ascq = sense_buffer[3];
+		sshdr->additional_length = sense_buffer[7];
+	} else {
+		/*
+		 * fixed format
+		 */
+		sshdr->sense_key = (sense_buffer[2] & 0xf);
+		sshdr->asc = sense_buffer[12];
+		sshdr->ascq = sense_buffer[13];
+	}
+
+	return 0;
+err:
+	return -1;
+}
+
+int query_identify(int fd, uint8_t *args)
+{
+#ifdef SG_IO
+	uint8_t cdb[SG_ATA_16_LEN] = { 0 };
+	uint8_t sensebuf[32] = { 0 }, *desc;
+	sg_io_hdr_t io_hdr = { 0 };
+	struct scsi_sense_hdr sshdr = { 0 };
+
+	/*
+	 * ATA PASS-THROUGH (16) CDB
+	 */
+	cdb[0] = SG_ATA_16;		/* OPERATION CODE (85h) */
+	cdb[1] = SG_ATA_PROTO_PIO_IN;	/* PIO Data-in */
+	/* no off.line or cc, read from dev,
+	 * block count in sector count field
+	 */
+	cdb[2] |= SG_CDB2_TLEN_NSECT;
+	cdb[2] |= SG_CDB2_TLEN_SECTORS;
+	cdb[2] |= SG_CDB2_TDIR_FROM_DEV;
+	cdb[13] = ATA_USING_LBA;	/* Device */
+	cdb[14] = args[0];		/* Command */
+
+	io_hdr.interface_id = 'S';
+	io_hdr.mx_sb_len = sizeof(sensebuf);
+	io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
+	io_hdr.dxfer_len = 512;
+	io_hdr.dxferp = args + 4;
+	io_hdr.cmdp = cdb;
+	io_hdr.cmd_len = SG_ATA_16_LEN;
+	io_hdr.sbp = sensebuf;
+	io_hdr.timeout = 15 * 1000; /* msecs */
+
+	if (ioctl(fd, SG_IO, &io_hdr) == -1)
+		goto use_legacy_ioctl;
+
+	/* sense data available */
+	if (io_hdr.driver_status == SG_DRIVER_SENSE) {
+		desc = sensebuf + 8;
+		/* SG_DRIVER_SENSE is not an error */
+		io_hdr.driver_status &= ~SG_DRIVER_SENSE;
+		/* If we set cc then ATA pass-through will cause a
+		 * check condition even if no error. Filter that. */
+		if (io_hdr.status & SG_CHECK_CONDITION) {
+			scsi_normalize_sense(sensebuf, &sshdr);
+			if (sshdr.sense_key == SG_RECOVERED_ERROR &&
+				sshdr.asc == 0 && sshdr.ascq == 0x1d)
+				io_hdr.status &= ~SG_CHECK_CONDITION;
+		}
+
+		/* return a few ATA registers */
+		if (sensebuf[0] == 0x72 &&	/* format is "descriptor" */
+			desc[0] == 0x09) {	/* ATA Descriptor Return */
+			args[0] = desc[13];	/* Status */
+			args[1] = desc[3];	/* Error */
+			args[2] = desc[5];	/* Sector Count (0:7) */
+		}
+	}
+
+	if (io_hdr.status || io_hdr.host_status || io_hdr.driver_status)
+		goto use_legacy_ioctl;
+
+	return 0;
+
+use_legacy_ioctl:
+#endif
+	return ioctl(fd, HDIO_DRIVE_CMD, args);
+}
+
+int check_trim_supported(int fd,
+			 int *trim,
+			 int *trim_blocks,
+			 int *trim_rzat)
+{
+	*trim = *trim_blocks = *trim_rzat = 0;
+
+	uint8_t args[4 + 512] = { 0 };
+	uint16_t *identify;
+	int i;
+
+	args[0] = ATA_OP_IDENTIFY;
+	if (query_identify(fd, args)) {
+		memset(args, 0, sizeof(args));
+		args[0] = ATA_OP_PIDENTIFY;
+		if (query_identify(fd, args)) {
+			perror("HDIO_DRIVE_CMD(identify) failed");
+			goto err;
+		}
+	}
+
+	/* byte-swap the little-endian IDENTIFY data
+	 * to match byte-order on host CPU
+	 */
+	identify = (uint16_t *)(args + 4);
+	for (i = 0; i < (512 >> 1); ++i)
+		__le16_to_cpus(&identify[i]);
+
+	/* TRIM bit - Identify Device word 169 bit 0
+	 * DRAT bit - Identify Device word 69 bit 14
+	 * RZAT bit - Identify Device word 69 bit 5
+	 * Maximum number of 512-byte blocks per DATA SET MANAGEMENT command
+	 * - Identify Device word 105
+	 *
+	 * If word 169 bit 0 is set to one and word 69 bit 14 is cleared to
+	 * zero, then the Trim function of the DATA SET MANAGEMENT command
+	 * (see 7.10.3.2) supports indeterminate read after trim behavior.
+	 * If word 169 bit 0 is set to one and word 69 bit 14 is set to one,
+	 * the Trim function of the DATA SET MANAGEMENT command supports
+	 * determinate read after trim behavior.
+	 * If word 169 bit 0 is cleared to zero,
+	 * then word 69 bit 14 is reserved.
+	 *
+	 * If word 69 bit 14 is set to one and word 69 bit 5 is set to one,
+	 * then a read operation after a Trim operation returns data from
+	 * trimmed LBAs as all words cleared to zero. If word 69 bit 14
+	 * is set to one and word 69 bit 5 is cleared to zero,
+	 * then a read operation after a Trim operation may have words
+	 * set to any value. If word 69 bit 14 is cleared to zero,
+	 * then word 69 bit 5 is reserved.
+	 *
+	 * See http://t13.org/Documents/UploadedDocuments/docs2009/e0
+	 * 9158r0-Trim_Clarifications.pdf for detail.
+	 */
+	const uint16_t trimd = 1 << 14;	/* deterministic read data after TRIM */
+	const uint16_t trimz = 1 << 5; /* deterministic read ZEROs after TRIM */
+	if (identify[169] & 1 && identify[169] != 0xffff) {/* support TRIM ? */
+		*trim = 1;
+
+		if (identify[69] & trimd) {
+			if (identify[105] && identify[105] != 0xffff)
+				*trim_blocks = (int)identify[105];
+			if (identify[69] & trimz)
+				*trim_rzat = 1;
+		}
+	}
+
+	return 0;
+err:
+	return -1;
+}
+
+int query_nvme_identify(int fd, uint8_t *args)
+{
+#ifdef NVME_IOCTL_ADMIN_CMD
+	struct nvme_passthru_cmd cmd = {
+		.opcode		= nvme_admin_identify,
+		.nsid		= 0,
+		.addr		= (uint64_t)args,
+		.data_len	= NVME_IDENTIFY_DATA_SIZE,
+		.cdw10		= 1,
+		.cdw11		= 0,
+	};
+
+	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd);
+#endif
+
+	return -1;
+}
+
+int check_nvme_trim_supported(int fd, int *trim)
+{
+	*trim = 0;
+
+	uint8_t args[NVME_IDENTIFY_DATA_SIZE] = { 0 };
+	uint16_t *oncs;
+
+	if (!query_nvme_identify(fd, args)) {
+		// offsetof(oncs, struct nvme_id_ctrl)
+		oncs = (uint16_t *)(args + 0x208);
+		__le16_to_cpus(&oncs[0]);
+		*trim = (oncs[0] & 0x4) >> 2;
+
+		return 0;
+	}
+
+	return -1;
+}
+
+int blkdiscard(int fd)
+{
+	uint64_t end, blksize, secsize, range[2];
+	struct stat sb;
+
+	range[0] = 0;
+	range[1] = ULLONG_MAX;
+
+	if (fstat(fd, &sb) == -1) {
+		perror("stat failed");
+		goto err;
+	}
+
+	if (!S_ISBLK(sb.st_mode)) {
+		fprintf(stderr, "is not a block device\n");
+		goto err;
+	}
+
+	if (ioctl(fd, BLKGETSIZE64, &blksize)) {
+		perror("BLKGETSIZE64 ioctl failed");
+		goto err;
+	}
+	if (ioctl(fd, BLKSSZGET, &secsize)) {
+		perror("BLKSSZGET ioctl failed");
+		goto err;
+	}
+
+	/* align range to the sector size */
+	range[0] = (range[0] + secsize - 1) & ~(secsize - 1);
+	range[1] &= ~(secsize - 1);
+
+	/* is the range end behind the end of the device ?*/
+	end = range[0] + range[1];
+	if (end < range[0] || end > blksize)
+		range[1] = blksize - range[0];
+
+	if (ioctl(fd, BLKDISCARD, &range)) {
+		perror("BLKDISCARD ioctl failed");
+		goto err;
+	}
+
+	return 0;
+err:
+	return -1;
+}
+
+void trim_all_sectors(char *path, int fd)
+{
+	char *dev = basename(path);
+	int trim_supported = 0;
+	int trim_blocks = 0;
+	int trim_rzat = 0;
+	if (!strncmp(dev, "nvme", 4))
+		check_nvme_trim_supported(fd, &trim_supported);
+	else
+		if (check_trim_supported(fd,
+					 &trim_supported,
+					 &trim_blocks,
+					 &trim_rzat))
+			check_nvme_trim_supported(fd, &trim_supported);
+
+	if (trim_supported) {
+		printf("TRIM:\t\t\tData Set Management TRIM supported");
+		if (trim_blocks)
+			printf(" (limit %d block%s)",
+				trim_blocks, trim_blocks > 1 ? "s" : "");
+		printf("\n");
+
+		if (trim_rzat) {
+			printf("RZAT:");
+			printf("\t\t\tDeterministic read ZEROs after TRIM\n");
+		}
+
+		printf("%s blkdiscard beginning...\n", path);
+		if (blkdiscard(fd))
+			fprintf(stderr, "%s blkdiscard failed: %s",
+					path, strerror(errno));
+		else
+			printf("%s blkdiscard successfully\n", path);
+	} else
+		printf("%s Skiping blkdiscard\n", path);
+}
+
 static void write_sb(char *dev, unsigned int block_size,
 			unsigned int bucket_size,
 			bool writeback, bool discard, bool wipe_bcache,
@@ -354,6 +654,11 @@ static void write_sb(char *dev, unsigned int block_size,
 		       sb.nr_in_set,
 		       sb.nr_this_dev,
 		       sb.first_bucket);
+
+		/* check whether cache dev supports TRIM or not.
+		 * if supports, trim all sectors
+		 */
+		trim_all_sectors(dev, fd);
 		putchar('\n');
 	}
 
@@ -429,7 +734,7 @@ int make_bcache(int argc, char **argv)
 	unsigned int i, ncache_devices = 0, nbacking_devices = 0;
 	char *cache_devices[argc];
 	char *backing_devices[argc];
-	char label[SB_LABEL_SIZE];
+	char label[SB_LABEL_SIZE] = { 0 };
 	unsigned int block_size = 0, bucket_size = 1024;
 	int writeback = 0, discard = 0, wipe_bcache = 0, force = 0;
 	unsigned int cache_replacement_policy = 0;
-- 
2.21.0


