Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17ED670044F
	for <lists+linux-bcache@lfdr.de>; Fri, 12 May 2023 11:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbjELJy6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 May 2023 05:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240582AbjELJyy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 May 2023 05:54:54 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2043.outbound.protection.outlook.com [40.107.244.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B79310E5E
        for <linux-bcache@vger.kernel.org>; Fri, 12 May 2023 02:54:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIWSiBUnoIDVST5Hz0Ehixj7xUtA0rmFJJ2vZFfrXKFMTst6Q20yZN3Z2ljccJc3BoeXU2XqNrxiWBT1tetyWf073y6KMwAPQBRw8DjiSEeNB0QpGKFZ1+CQ9OCMSxAaZcucADdEAT/MF27hVBBzzYJWVxmWjkzGQ2efUbeQluOMPGv30CLsO3z796dHrdF5NVSC6W0A6dGdAs4ST3uGz5UOj+RB3FdKsCMlhAK5CigdYwRZ8728Xdbtxu3riMdAvoUwelZoixPGIW2PO7CX+dEf2MXZZdUiEPbuI6Be9QwgGkaTF0+0Nuzxofr2nOk3aCLXhf+U9rl+vu27Oh80Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fe0W9CzgQMkeo7l9UpbArE5wgy5gvr1yA9CbkY6f4YM=;
 b=PDWpC3LL3UhBk6/j3rUEECSlkq+KhXu2HgCH38YJOsiFSWprYBdlzUDAQqOQSh6LjMYvnz6IJqczDP7xfeCqz5B4BdKjrxl0JEqGMOehDobS5av7ssyQlZJsFTfrd24/tE7lcN7o2Pcls0GAbrbFFpy6vW51L7mZjzFYKNFdRm2bqUEZxfLij/2n/4C+WOtsdi6ejg8sm4C08OGKwxEkxcgKFsWIrCSMRSdUiCWU6VLVTmRJ8whdG83mH7HChbCpm5sM/OnK/jVccB0KD9GoGG/PvXKU2RxnqczwvyZz8QX9ozwWXZrvsEAzpLALlsPhqtD0pvHK3xNGVxpwD8y2Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=suse.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fe0W9CzgQMkeo7l9UpbArE5wgy5gvr1yA9CbkY6f4YM=;
 b=ABS5jIeDSkV/P7kQjl/6F1SD+k4ucLHpMK9VQxnZGqBNzERQPY5sXPfLzOv1U8puGRLx6THjly5mNMMaiKoS1w9s8ZlgJOd+RIufULSXlPoz7TPjJEpr/MAf/qdGltxgxFf9a1da5LR/hw27fN0/9nbkbHg7h5fdBr2HLMvzaLSMu9bBm0vdQ8s4lqJcj3OruXPoSttiTauhSS0FXC30+m5x+fHZAeidrT6bSF/qw0MlZg1WjKb5acOQYk3Aig4h178HNLKIedb/dDz1QlEQzDy9jKaUKctZr4d57n1SnCljF74UNua02H0PPN37GHI5fGoL/KjL0z8QVCs7wBIWMQ==
Received: from BN9P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::26)
 by CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.23; Fri, 12 May
 2023 09:54:38 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::2) by BN9P220CA0021.outlook.office365.com
 (2603:10b6:408:13e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22 via Frontend
 Transport; Fri, 12 May 2023 09:54:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.24 via Frontend Transport; Fri, 12 May 2023 09:54:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 12 May 2023
 02:54:27 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 12 May
 2023 02:54:27 -0700
From:   Chaitanya Kulkarni <kch@nvidia.com>
To:     <colyli@suse.de>, <kent.overstreet@gmail.com>
CC:     <linux-bcache@vger.kernel.org>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 0/1] bcache: allow user to set QUEUE_FLAG_NOWAIT 
Date:   Fri, 12 May 2023 02:54:19 -0700
Message-ID: <20230512095420.12578-1-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT044:EE_|CO6PR12MB5444:EE_
X-MS-Office365-Filtering-Correlation-Id: 744e8c00-0e22-435a-04f3-08db52cee636
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /3dP1JQAugdzmTMlWoby2hqIHYlgeOg9RWdoUL/z8PHDz4tUy97v2wX2EH4puwZZQjgUCisKa/Eu//6oSjlGS+Qn4wRlONlOkLaPWX2m5lkPX/YmxIGrKMsnZxhriil05nJ9Xp2XTz68/LfIZZVPg1P0gPY6kB67lYg1+vhwkdhfxa0d51zy3FTxO4bqF04e+XtkOLz9KKVafOKPn2FO/9AOZQxZTTQZb1DVY+lAJyOgCeBR5/wAGXCgJPZInMBWgxlSq24jWTRF6ULmDcxJ/xgbAgPYA1iwKxibraPpzOzTW2kOav8IQcTwPeHI73O4fu9vhp9Pt/VD+Zv0eGMgV6LHFyoGESN0A09YqwC64JM94O3ejJ+EY4DPKi5N8KM852wHPPE6BF7eDS11moyX/KhgLfLqWv+BMIzUNnA5WMr6oqcq5wo8Jv+mnre7kwhH5So4yvHBFSpSB+88sMN+up4AQq8Q2xsxUtnDaD6xE6feLEoUzEgthHeWkW7bYMWmeDa8ZHY1+zQwWS2eFHmX9+ObA6PWDwU95N4vFb6JuRzc6o02BKf2Z/uYpcRbY+FB4z4Dcgi46ayJcFihGhL0w4iHAQNfZfagqwCptxlZHKFr89rX30nvzbl9RQP4XqYliyMSmSUR1FEVSLLAVALjrHqPkkimvO8kLdI5tGg8DXQPhAclG0WTir797ZY+LD9sABb5Ky4kbdRfRJuvJy69JpqfTk4Y4fDBN9zIJ63/21KZgY2lrrClZaJAKVMSeAJy
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(82310400005)(47076005)(7696005)(40460700003)(54906003)(110136005)(41300700001)(316002)(6666004)(478600001)(36756003)(70586007)(4326008)(40480700001)(1076003)(26005)(7636003)(83380400001)(2616005)(186003)(4743002)(16526019)(82740400003)(336012)(426003)(356005)(5660300002)(8676002)(8936002)(2906002)(30864003)(70206006)(36860700001)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 09:54:38.0222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 744e8c00-0e22-435a-04f3-08db52cee636
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5444
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Allow user to set the QUEUE_FLAG_NOWAIT optionally using module
parameter to retain the default behaviour. Also, update respective
allocation flags in the write path. Following are the performance
numbers with io_uring fio engine for random read, note that device has
been populated fully with randwrite workload before taking these
numbers :-

* linux-block (for-next) # grep IOPS  bc-*fio | column -t

nowait-off-1.fio:  read:  IOPS=482k,  BW=1885MiB/s
nowait-off-2.fio:  read:  IOPS=484k,  BW=1889MiB/s
nowait-off-3.fio:  read:  IOPS=483k,  BW=1886MiB/s

nowait-on-1.fio:   read:  IOPS=544k,  BW=2125MiB/s
nowait-on-2.fio:   read:  IOPS=547k,  BW=2137MiB/s
nowait-on-3.fio:   read:  IOPS=546k,  BW=2132MiB/s

* linux-block (for-next) # grep slat  bc-*fio | column -t

nowait-off-1.fio: slat (nsec):  min=430, max=5488.5k, avg=2797.52
nowait-off-2.fio: slat (nsec):  min=431, max=8252.4k, avg=2805.33
nowait-off-3.fio: slat (nsec):  min=431, max=6846.6k, avg=2814.57

nowait-on-1.fio:  slat (usec):  min=2,   max=39086,   avg=87.48
nowait-on-2.fio:  slat (usec):  min=3,   max=39519,   avg=86.98
nowait-on-3.fio:  slat (usec):  min=3,   max=38880,   avg=87.17

* linux-block (for-next) # grep cpu  bc-*fio | column -t

nowait-off-1.fio:  cpu  :  usr=2.77%,  sys=6.57%,   ctx=22015526
nowait-off-2.fio:  cpu  :  usr=2.75%,  sys=6.59%,   ctx=22003700
nowait-off-3.fio:  cpu  :  usr=2.81%,  sys=6.57%,   ctx=21938309

nowait-on-1.fio:   cpu  :  usr=1.08%,  sys=78.39%,  ctx=2744092
nowait-on-2.fio:   cpu  :  usr=1.10%,  sys=79.76%,  ctx=2537466
nowait-on-3.fio:   cpu  :  usr=1.10%,  sys=79.88%,  ctx=2528092

Please let me know if further testing is needed I've ran fio
verification job in order to make verify these changes.

-ck

Chaitanya Kulkarni (1):
  bcache: allow user to set QUEUE_FLAG_NOWAIT

 drivers/md/bcache/request.c | 3 ++-
 drivers/md/bcache/super.c   | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)
linux-block (for-next) # sh test-bcache.sh 
+ git log -1
commit de812ff5f3c9819c83d6eaaed076a031a4b7be4a (HEAD -> for-next)
Author: Chaitanya Kulkarni <kch@nvidia.com>
Date:   Fri May 12 02:08:19 2023 -0700

    bcache: allow user to set QUEUE_FLAG_NOWAIT
    
    Allow user to set the QUEUE_FLAG_NOWAIT optionally using module
    parameter to retain the default behaviour. Also, update respective
    allocation flags in the write path. Following are the performance
    numbers with io_uring fio engine for random read, note that device has
    been populated fully with randwrite workload before taking these
    numbers :-
+ rmmod bcache.ko
rmmod: ERROR: Module bcache is not currently loaded
+ rmmod null_blk
rmmod: ERROR: Module null_blk is not currently loaded
+ makej M=drivers/md/bcache
+ modprobe null_blk queue_mode=2 nr_devices=2 memory_backed=1 gb=1
+ insmod drivers/md/bcache/bcache.ko
+ test_bcache default-nowait-off
+ bcache make -B /dev/nullb0 -C /dev/nullb1
Name			/dev/nullb1
Label			
Type			cache
UUID:			36da1586-91a1-4629-a639-ed07d4a8e4fa
Set UUID:		614c08a8-975f-4eb4-a047-b589e586ffeb
version:		0
nbuckets:		2048
block_size_in_sectors:	1
bucket_size_in_sectors:	1024
nr_in_set:		1
nr_this_dev:		0
first_bucket:		1
                                ...
Name			/dev/nullb0
Label			
Type			data
UUID:			1828367c-7859-4533-830e-b9594bc7ada5
Set UUID:		614c08a8-975f-4eb4-a047-b589e586ffeb
version:		1
block_size_in_sectors:	1
data_offset_in_sectors:	16

+ sleep 1
+ echo /dev/nullb0
+ echo /dev/nullb1
+ dmesg -c
[ 2428.580341] bcache: bcache_device_free() bcache0 stopped
[ 2428.581555] bcache: cache_set_free() Cache set 5eecd8b5-12f9-4863-9c31-a7cf4c98e080 unregistered
[ 2434.003724] null_blk: disk nullb0 created
[ 2434.004672] null_blk: disk nullb1 created
[ 2434.004674] null_blk: module loaded
[ 2435.037634] bcache: register_bdev() registered backing device nullb0
[ 2435.038927] bcache: run_cache_set() invalidating existing data
[ 2435.044138] bcache: bch_cached_dev_run() cached dev nullb0 is running already
[ 2435.044149] bcache: bch_cached_dev_attach() Caching nullb0 as bcache0 on set 614c08a8-975f-4eb4-a047-b589e586ffeb
[ 2435.044162] bcache: register_cache() registered cache device nullb1
+ lsblk
NAME      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda         8:0    0   50G  0 disk 
├─sda1      8:1    0    1G  0 part /boot
└─sda2      8:2    0   49G  0 part /home
sdb         8:16   0  100G  0 disk /mnt/data
sr0        11:0    1 1024M  0 rom  
nullb0    251:0    0    1G  0 disk 
└─bcache0 250:0    0 1024M  0 disk 
nullb1    251:1    0    1G  0 disk 
└─bcache0 250:0    0 1024M  0 disk 
vda       252:0    0    5G  0 disk 
nvme0n1   259:0    0    1G  0 disk 
+ sleep 1
+ fio fio/verify.fio --ioengine=io_uring --size=1G --filename=/dev/bcache0
write-and-verify: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=16
fio-3.34
Starting 1 process
verify: bad header numberio 63917, wanted 64003 at file /dev/bcache0 offset 701530112, length 4096 (requested block: offset=701530112, length=4096)
fio: pid=9319, err=84/file:io_u.c:2203, func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide character

write-and-verify: (groupid=0, jobs=1): err=84 (file:io_u.c:2203, func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide character): pid=9319: Fri May 12 02:35:17 2023
  read: IOPS=237k, BW=925MiB/s (969MB/s)(423MiB/458msec)
    slat (nsec): min=380, max=97285, avg=2778.70, stdev=1563.26
    clat (usec): min=14, max=23014, avg=63.83, stdev=282.43
     lat (usec): min=17, max=23051, avg=66.61, stdev=282.51
    clat percentiles (usec):
     |  1.00th=[   31],  5.00th=[   35], 10.00th=[   40], 20.00th=[   49],
     | 30.00th=[   53], 40.00th=[   57], 50.00th=[   59], 60.00th=[   62],
     | 70.00th=[   64], 80.00th=[   68], 90.00th=[   75], 95.00th=[   85],
     | 99.00th=[  111], 99.50th=[  122], 99.90th=[  889], 99.95th=[ 1483],
     | 99.99th=[22938]
  write: IOPS=144k, BW=564MiB/s (591MB/s)(1024MiB/1817msec); 0 zone resets
    slat (nsec): min=1152, max=429216, avg=4099.27, stdev=2026.69
    clat (usec): min=11, max=19407, avg=106.50, stdev=458.31
     lat (usec): min=14, max=19411, avg=110.60, stdev=458.36
    clat percentiles (usec):
     |  1.00th=[   35],  5.00th=[   42], 10.00th=[   47], 20.00th=[   57],
     | 30.00th=[   64], 40.00th=[   69], 50.00th=[   73], 60.00th=[   77],
     | 70.00th=[   82], 80.00th=[   91], 90.00th=[  113], 95.00th=[  137],
     | 99.00th=[  685], 99.50th=[ 1500], 99.90th=[ 6915], 99.95th=[12649],
     | 99.99th=[16581]
   bw (  KiB/s): min=379328, max=626696, per=90.85%, avg=524288.00, stdev=105971.00, samples=4
   iops        : min=94832, max=156674, avg=131072.00, stdev=26492.75, samples=4
  lat (usec)   : 20=0.02%, 50=15.72%, 100=73.22%, 250=9.76%, 500=0.39%
  lat (usec)   : 750=0.21%, 1000=0.15%
  lat (msec)   : 2=0.27%, 4=0.14%, 10=0.08%, 20=0.05%, 50=0.01%
  cpu          : usr=33.29%, sys=38.70%, ctx=21042, majf=0, minf=4559
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=108396,262144,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=925MiB/s (969MB/s), 925MiB/s-925MiB/s (969MB/s-969MB/s), io=423MiB (444MB), run=458-458msec
  WRITE: bw=564MiB/s (591MB/s), 564MiB/s-564MiB/s (591MB/s-591MB/s), io=1024MiB (1074MB), run=1817-1817msec

Disk stats (read/write):
    bcache0: ios=78845/262144, merge=0/0, ticks=1327/10762, in_queue=12089, util=95.41%, aggrios=54450/263725, aggrmerge=0/0, aggrticks=376/2102, aggrin_queue=2479, aggrutil=90.70%
  nullb1: ios=105255/265306, merge=0/0, ticks=739/879, in_queue=1619, util=90.70%
  nullb0: ios=3646/262144, merge=0/0, ticks=13/3326, in_queue=3340, util=83.61%
+ fio fio/randwrite.fio --ioengine=io_uring --size=1G --filename=/dev/bcache0
RANDWRITE: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=2
...
fio-3.34
Starting 48 processes
Jobs: 48 (f=48): [w(48)][100.0%][w=764MiB/s][w=196k IOPS][eta 00m:00s]
RANDWRITE: (groupid=0, jobs=48): err= 0: pid=9341: Fri May 12 02:36:18 2023
  write: IOPS=196k, BW=766MiB/s (803MB/s)(44.9GiB/60003msec); 0 zone resets
    slat (nsec): min=421, max=4604.7k, avg=3817.54, stdev=7945.41
    clat (nsec): min=271, max=82444k, avg=484832.20, stdev=1610621.78
     lat (usec): min=10, max=82448, avg=488.65, stdev=1610.67
    clat percentiles (usec):
     |  1.00th=[   35],  5.00th=[   65], 10.00th=[  118], 20.00th=[  153],
     | 30.00th=[  192], 40.00th=[  233], 50.00th=[  265], 60.00th=[  302],
     | 70.00th=[  359], 80.00th=[  445], 90.00th=[  652], 95.00th=[ 1172],
     | 99.00th=[ 2868], 99.50th=[18220], 99.90th=[22152], 99.95th=[23200],
     | 99.99th=[25560]
   bw (  KiB/s): min=619732, max=1020653, per=100.00%, avg=785206.50, stdev=1535.24, samples=5712
   iops        : min=154933, max=255162, avg=196300.83, stdev=383.81, samples=5712
  lat (nsec)   : 500=0.01%, 750=0.01%, 1000=0.01%
  lat (usec)   : 2=0.01%, 4=0.01%, 10=0.01%, 20=0.07%, 50=3.23%
  lat (usec)   : 100=4.59%, 250=37.78%, 500=38.49%, 750=7.77%, 1000=2.29%
  lat (msec)   : 2=3.49%, 4=1.60%, 10=0.10%, 20=0.30%, 50=0.27%
  lat (msec)   : 100=0.01%
  cpu          : usr=3.09%, sys=7.08%, ctx=10143891, majf=0, minf=604
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,11763871,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=2

Run status group 0 (all jobs):
  WRITE: bw=766MiB/s (803MB/s), 766MiB/s-766MiB/s (803MB/s-803MB/s), io=44.9GiB (48.2GB), run=60003-60003msec

Disk stats (read/write):
    bcache0: ios=88/11739287, merge=0/0, ticks=1/4439670, in_queue=4439671, util=99.53%, aggrios=478/11792831, aggrmerge=0/0, aggrticks=12/507616, aggrin_queue=507628, aggrutil=96.79%
  nullb1: ios=821/11821791, merge=0/0, ticks=21/71099, in_queue=71119, util=96.79%
  nullb0: ios=135/11763871, merge=0/0, ticks=4/944133, in_queue=944138, util=77.31%
+ for i in 1 2 3
+ fio fio/randread.fio --ioengine=io_uring --size=1G --filename=/dev/bcache0 --output=bc-default-nowait-off-1.fio
+ for i in 1 2 3 [r(48)][100.0%][r=1963MiB/s][r=503k IOPS][eta 00m:00s]
+ fio fio/randread.fio --ioengine=io_uring --size=1G --filename=/dev/bcache0 --output=bc-default-nowait-off-2.fio
+ for i in 1 2 3 [r(48)][100.0%][r=1988MiB/s][r=509k IOPS][eta 00m:00s]
+ fio fio/randread.fio --ioengine=io_uring --size=1G --filename=/dev/bcache0 --output=bc-default-nowait-off-3.fio
+ bcache unregister /dev/nullb0][r=1896MiB/s][r=485k IOPS][eta 00m:00s]
+ bcache unregister /dev/nullb1
+ rmmod bcache.ko
+ rmmod null_blk
+ modprobe null_blk queue_mode=2 nr_devices=2 memory_backed=1 gb=1
+ insmod drivers/md/bcache/bcache.ko bch_nowait=1
+ test_bcache nowait-on
+ bcache make -B /dev/nullb0 -C /dev/nullb1
Name			/dev/nullb1
Label			
Type			cache
UUID:			3960cc68-78c3-4e42-8a72-29a19ec6a97b
Set UUID:		bf11b3de-6bc8-42a5-8fd4-66ad7304b9b3
version:		0
nbuckets:		2048
block_size_in_sectors:	1
bucket_size_in_sectors:	1024
nr_in_set:		1
nr_this_dev:		0
first_bucket:		1
                                ...
Name			/dev/nullb0
Label			
Type			data
UUID:			451f8df6-b94c-478c-bd2f-f959f32593c8
Set UUID:		bf11b3de-6bc8-42a5-8fd4-66ad7304b9b3
version:		1
block_size_in_sectors:	1
data_offset_in_sectors:	16

+ sleep 1
+ echo /dev/nullb0
+ echo /dev/nullb1
+ dmesg -c
[ 2679.514049] bcache: bcache_device_free() bcache0 stopped
[ 2679.515264] bcache: cache_set_free() Cache set 614c08a8-975f-4eb4-a047-b589e586ffeb unregistered
[ 2679.596435] null_blk: disk nullb0 created
[ 2679.597466] null_blk: disk nullb1 created
[ 2679.597468] null_blk: module loaded
[ 2680.630189] bcache: register_bdev() registered backing device nullb0
[ 2680.631427] bcache: run_cache_set() invalidating existing data
[ 2680.634930] bcache: bch_cached_dev_run() cached dev nullb0 is running already
[ 2680.634945] bcache: bch_cached_dev_attach() Caching nullb0 as bcache0 on set bf11b3de-6bc8-42a5-8fd4-66ad7304b9b3
[ 2680.634959] bcache: register_cache() registered cache device nullb1
+ lsblk
NAME      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda         8:0    0   50G  0 disk 
├─sda1      8:1    0    1G  0 part /boot
└─sda2      8:2    0   49G  0 part /home
sdb         8:16   0  100G  0 disk /mnt/data
sr0        11:0    1 1024M  0 rom  
nullb0    251:0    0    1G  0 disk 
└─bcache0 250:0    0 1024M  0 disk 
nullb1    251:1    0    1G  0 disk 
└─bcache0 250:0    0 1024M  0 disk 
vda       252:0    0    5G  0 disk 
nvme0n1   259:0    0    1G  0 disk 
+ sleep 1
+ fio fio/verify.fio --ioengine=io_uring --size=1G --filename=/dev/bcache0
write-and-verify: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=16
fio-3.34
Starting 1 process
Jobs: 1 (f=1): [V(1)][57.1%][r=5089KiB/s,w=251MiB/s][r=1272,w=64.4k IOPS][eta 00m:03s]
write-and-verify: (groupid=0, jobs=1): err= 0: pid=9962: Fri May 12 02:39:25 2023
  read: IOPS=203k, BW=792MiB/s (830MB/s)(647MiB/817msec)
    slat (usec): min=2, max=4887, avg= 4.01, stdev=20.39
    clat (nsec): min=80, max=5611.0k, avg=74109.33, stdev=92291.20
     lat (usec): min=2, max=5623, avg=78.12, stdev=95.01
    clat percentiles (usec):
     |  1.00th=[   16],  5.00th=[   59], 10.00th=[   60], 20.00th=[   61],
     | 30.00th=[   63], 40.00th=[   67], 50.00th=[   68], 60.00th=[   70],
     | 70.00th=[   73], 80.00th=[   76], 90.00th=[   83], 95.00th=[   98],
     | 99.00th=[  143], 99.50th=[  174], 99.90th=[ 1713], 99.95th=[ 2040],
     | 99.99th=[ 2278]
  write: IOPS=67.4k, BW=263MiB/s (276MB/s)(1024MiB/3887msec); 0 zone resets
    slat (usec): min=4, max=4882, avg=12.71, stdev=39.18
    clat (nsec): min=161, max=106211k, avg=224208.69, stdev=951424.56
     lat (usec): min=9, max=106224, avg=236.92, stdev=952.58
    clat percentiles (usec):
     |  1.00th=[   87],  5.00th=[  128], 10.00th=[  137], 20.00th=[  143],
     | 30.00th=[  149], 40.00th=[  159], 50.00th=[  176], 60.00th=[  184],
     | 70.00th=[  192], 80.00th=[  210], 90.00th=[  269], 95.00th=[  322],
     | 99.00th=[ 1029], 99.50th=[ 1614], 99.90th=[ 9110], 99.95th=[14091],
     | 99.99th=[21627]
   bw (  KiB/s): min=185096, max=314112, per=97.18%, avg=262144.00, stdev=45100.35, samples=8
   iops        : min=46274, max=78528, avg=65536.00, stdev=11275.09, samples=8
  lat (nsec)   : 100=0.03%, 250=0.25%, 500=0.01%, 750=0.01%, 1000=0.01%
  lat (usec)   : 4=0.02%, 10=0.05%, 20=0.08%, 50=0.43%, 100=36.75%
  lat (usec)   : 250=54.54%, 500=6.33%, 750=0.41%, 1000=0.38%
  lat (msec)   : 2=0.48%, 4=0.12%, 10=0.06%, 20=0.04%, 50=0.01%
  lat (msec)   : 250=0.01%
  cpu          : usr=17.58%, sys=54.71%, ctx=260303, majf=0, minf=4542
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=165554,262144,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=792MiB/s (830MB/s), 792MiB/s-792MiB/s (830MB/s-830MB/s), io=647MiB (678MB), run=817-817msec
  WRITE: bw=263MiB/s (276MB/s), 263MiB/s-263MiB/s (276MB/s-276MB/s), io=1024MiB (1074MB), run=3887-3887msec

Disk stats (read/write):
    bcache0: ios=152330/262144, merge=0/0, ticks=618/10341, in_queue=10959, util=97.68%, aggrios=83009/263342, aggrmerge=0/0, aggrticks=128/1245, aggrin_queue=1373, aggrutil=90.86%
  nullb1: ios=155789/264540, merge=0/0, ticks=229/623, in_queue=852, util=90.86%
  nullb0: ios=10229/262144, merge=0/0, ticks=28/1867, in_queue=1895, util=89.00%
+ fio fio/randwrite.fio --ioengine=io_uring --size=1G --filename=/dev/bcache0
RANDWRITE: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=2
...
fio-3.34
Starting 48 processes
Jobs: 46 (f=46): [w(35),_(1),w(4),_(1),w(7)][95.3%][w=762MiB/s][w=195k IOPS][eta 00m:03s]
RANDWRITE: (groupid=0, jobs=48): err= 0: pid=10046: Fri May 12 02:40:26 2023
  write: IOPS=206k, BW=804MiB/s (843MB/s)(47.1GiB/60016msec); 0 zone resets
    slat (nsec): min=1002, max=24597k, avg=146865.06, stdev=202132.32
    clat (nsec): min=110, max=83997k, avg=318946.95, stdev=1533223.26
     lat (usec): min=7, max=84012, avg=465.81, stdev=1551.87
    clat percentiles (nsec):
     |  1.00th=[     322],  5.00th=[   16512], 10.00th=[   21120],
     | 20.00th=[   65280], 30.00th=[  100864], 40.00th=[  110080],
     | 50.00th=[  116224], 60.00th=[  123392], 70.00th=[  136192],
     | 80.00th=[  162816], 90.00th=[  329728], 95.00th=[  790528],
     | 99.00th=[ 2867200], 99.50th=[17432576], 99.90th=[21364736],
     | 99.95th=[22413312], 99.99th=[24510464]
   bw (  KiB/s): min=483303, max=1030912, per=100.00%, avg=824214.25, stdev=2303.88, samples=5710
   iops        : min=120824, max=257728, avg=206051.21, stdev=575.97, samples=5710
  lat (nsec)   : 250=0.54%, 500=1.46%, 750=0.45%, 1000=0.14%
  lat (usec)   : 2=0.05%, 4=0.01%, 10=0.01%, 20=6.20%, 50=9.97%
  lat (usec)   : 100=10.80%, 250=58.00%, 500=4.66%, 750=2.61%, 1000=0.49%
  lat (msec)   : 2=2.36%, 4=1.60%, 10=0.08%, 20=0.38%, 50=0.19%
  lat (msec)   : 100=0.01%
  cpu          : usr=0.53%, sys=51.34%, ctx=12806805, majf=0, minf=671
  IO depths    : 1=0.1%, 2=100.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,12345076,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=2

Run status group 0 (all jobs):
  WRITE: bw=804MiB/s (843MB/s), 804MiB/s-804MiB/s (843MB/s-843MB/s), io=47.1GiB (50.6GB), run=60016-60016msec

Disk stats (read/write):
    bcache0: ios=176/12313695, merge=0/0, ticks=13/3916805, in_queue=3916818, util=98.25%, aggrios=959/12338321, aggrmerge=0/0, aggrticks=55/222368, aggrin_queue=222424, aggrutil=96.02%
  nullb1: ios=1641/12331567, merge=0/0, ticks=86/51128, in_queue=51214, util=96.02%
  nullb0: ios=277/12345076, merge=0/0, ticks=24/393609, in_queue=393634, util=76.64%
+ for i in 1 2 3
+ fio fio/randread.fio --ioengine=io_uring --size=1G --filename=/dev/bcache0 --output=bc-nowait-on-1.fio
+ for i in 1 2 3 [r(48)][100.0%][r=2086MiB/s][r=534k IOPS][eta 00m:00s]
+ fio fio/randread.fio --ioengine=io_uring --size=1G --filename=/dev/bcache0 --output=bc-nowait-on-2.fio
+ for i in 1 2 3 [r(48)][100.0%][r=2185MiB/s][r=559k IOPS][eta 00m:00s]
+ fio fio/randread.fio --ioengine=io_uring --size=1G --filename=/dev/bcache0 --output=bc-nowait-on-3.fio
+ bcache unregister /dev/nullb0][r=2148MiB/s][r=550k IOPS][eta 00m:00s]
+ bcache unregister /dev/nullb1
+ rmmod bcache.ko
+ rmmod null_blk
linux-block (for-next) # for i in IOPS slat cpu; do grep $i bc-*fio | column -t ; done
bc-default-nowait-off-1.fio:  read:  IOPS=482k,  BW=1885MiB/s  (1976MB/s)(110GiB/60003msec)
bc-default-nowait-off-2.fio:  read:  IOPS=484k,  BW=1889MiB/s  (1981MB/s)(111GiB/60002msec)
bc-default-nowait-off-3.fio:  read:  IOPS=483k,  BW=1886MiB/s  (1978MB/s)(111GiB/60002msec)
bc-nowait-on-1.fio:           read:  IOPS=544k,  BW=2125MiB/s  (2228MB/s)(124GiB/60001msec)
bc-nowait-on-2.fio:           read:  IOPS=547k,  BW=2137MiB/s  (2241MB/s)(125GiB/60002msec)
bc-nowait-on-3.fio:           read:  IOPS=546k,  BW=2132MiB/s  (2236MB/s)(125GiB/60001msec)
bc-default-nowait-off-1.fio:  slat  (nsec):  min=430,  max=5488.5k,  avg=2797.52,  stdev=5775.84
bc-default-nowait-off-2.fio:  slat  (nsec):  min=431,  max=8252.4k,  avg=2805.33,  stdev=6216.69
bc-default-nowait-off-3.fio:  slat  (nsec):  min=431,  max=6846.6k,  avg=2814.57,  stdev=6309.09
bc-nowait-on-1.fio:           slat  (usec):  min=2,    max=39086,    avg=87.48,    stdev=427.87
bc-nowait-on-2.fio:           slat  (usec):  min=3,    max=39519,    avg=86.98,    stdev=425.06
bc-nowait-on-3.fio:           slat  (usec):  min=3,    max=38880,    avg=87.17,    stdev=427.17
bc-default-nowait-off-1.fio:  cpu  :  usr=2.77%,  sys=6.57%,   ctx=22015526,  majf=0,  minf=697
bc-default-nowait-off-2.fio:  cpu  :  usr=2.75%,  sys=6.59%,   ctx=22003700,  majf=0,  minf=666
bc-default-nowait-off-3.fio:  cpu  :  usr=2.81%,  sys=6.57%,   ctx=21938309,  majf=0,  minf=659
bc-nowait-on-1.fio:           cpu  :  usr=1.08%,  sys=78.39%,  ctx=2744092,   majf=0,  minf=794
bc-nowait-on-2.fio:           cpu  :  usr=1.10%,  sys=79.76%,  ctx=2537466,   majf=0,  minf=787
bc-nowait-on-3.fio:           cpu  :  usr=1.10%,  sys=79.88%,  ctx=2528092,   majf=0,  minf=788
linux-block (for-next) # 

