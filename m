Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6C72A8874
	for <lists+linux-bcache@lfdr.de>; Thu,  5 Nov 2020 21:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732043AbgKEU6A (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Nov 2020 15:58:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16442 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbgKEU6A (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Nov 2020 15:58:00 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A5KuOAk106406;
        Thu, 5 Nov 2020 15:57:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=uIaPG9KOvlm0C7hDrH8NX5ORxxb/hO/D/dXfsLrewTk=;
 b=aDt+mWvklXfmHhHG+r46Ld+1w9kYvuX5tZDw4VQ2XINT6U6AL8jkzD7BtLcRmZ41fY5F
 EvdzpDppKiOthGc2PGcVJ5zo99X5EvjzHpFprz85OGg8QqD1EU7JHi0v/SXHHMP9slZF
 EaFZlvLbKbJngPv2gUcEmNmWJuB0kmVqOluBupuLD/OkzEi5jSXgO0+mbvsrc7qQfxER
 T7vWWmCWzuUOlXTzRDcqR0stKq0TgmVar83wN6hlzMSZKwldiE/ZDU3si+IBPZxFLTlL
 ckzhFCNGXbwoWR01rcNxSYKJkR6nta128L3X9577wTenqsU/HOenT3S9recPyDQEGxl5 Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34mfdgne75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 15:57:03 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A5Kv3IJ108031;
        Thu, 5 Nov 2020 15:57:03 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34mfdgne68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 15:57:02 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A5Kv0qE019035;
        Thu, 5 Nov 2020 20:57:00 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 34h01kk0bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 20:57:00 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A5Kuwve41484616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Nov 2020 20:56:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E060A4051;
        Thu,  5 Nov 2020 20:56:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0026A4040;
        Thu,  5 Nov 2020 20:56:57 +0000 (GMT)
Received: from imap.linux.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  5 Nov 2020 20:56:57 +0000 (GMT)
Date:   Thu, 5 Nov 2020 21:56:47 +0100
From:   Stefan Haberland <sth@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 06/10] dasd: implement ->set_read_only to hook into
 BLKROSET processing
Message-ID: <20201105205634.GA78869@imap.linux.ibm.com>
References: <20201103100018.683694-1-hch@lst.de>
 <20201103100018.683694-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103100018.683694-7-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_14:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 clxscore=1011 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050129
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Christoph Hellwig <hch@lst.de> schrieb am Tue, 03. Nov 11:00:
> Implement the ->set_read_only method instead of parsing the actual
> ioctl command.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/s390/block/dasd.c       |  1 +
>  drivers/s390/block/dasd_int.h   |  3 ++-
>  drivers/s390/block/dasd_ioctl.c | 27 +++++++++------------------
>  3 files changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
> index eb17fea8075c6f..db24e04ee9781e 100644
> --- a/drivers/s390/block/dasd.c
> +++ b/drivers/s390/block/dasd.c
> @@ -3394,6 +3394,7 @@ dasd_device_operations = {
>  	.ioctl		= dasd_ioctl,
>  	.compat_ioctl	= dasd_ioctl,
>  	.getgeo		= dasd_getgeo,
> +	.set_read_only	= dasd_set_read_only,
>  };
>  
>  /*******************************************************************************
> diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
> index fa552f9f166671..c59a0d63b506e6 100644
> --- a/drivers/s390/block/dasd_int.h
> +++ b/drivers/s390/block/dasd_int.h
> @@ -844,7 +844,8 @@ int dasd_scan_partitions(struct dasd_block *);
>  void dasd_destroy_partitions(struct dasd_block *);
>  
>  /* externals in dasd_ioctl.c */
> -int  dasd_ioctl(struct block_device *, fmode_t, unsigned int, unsigned long);
> +int dasd_ioctl(struct block_device *, fmode_t, unsigned int, unsigned long);
> +int dasd_set_read_only(struct block_device *bdev, bool ro);
>  
>  /* externals in dasd_proc.c */
>  int dasd_proc_init(void);
> diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
> index cb6427fb9f3d16..3359559517bfcf 100644
> --- a/drivers/s390/block/dasd_ioctl.c
> +++ b/drivers/s390/block/dasd_ioctl.c
> @@ -532,28 +532,22 @@ static int dasd_ioctl_information(struct dasd_block *block, void __user *argp,
>  /*
>   * Set read only
>   */
> -static int
> -dasd_ioctl_set_ro(struct block_device *bdev, void __user *argp)
> +int dasd_set_read_only(struct block_device *bdev, bool ro)
>  {
>  	struct dasd_device *base;
> -	int intval, rc;
> +	int rc;
>  
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EACCES;
> +	/* do not manipulate hardware state for partitions */
>  	if (bdev_is_partition(bdev))
> -		// ro setting is not allowed for partitions
> -		return -EINVAL;
> -	if (get_user(intval, (int __user *)argp))
> -		return -EFAULT;
> +		return 0;
> +
>  	base = dasd_device_from_gendisk(bdev->bd_disk);
>  	if (!base)
>  		return -ENODEV;
> -	if (!intval && test_bit(DASD_FLAG_DEVICE_RO, &base->flags)) {
> -		dasd_put_device(base);
> -		return -EROFS;
> -	}
> -	set_disk_ro(bdev->bd_disk, intval);


While testing this patch I just noticed that when I set a device readonly this is
not going to be passed on to the partitions on this device any longer.

This is caused by the removed call to set_disk_ro().

Is this intentional or was this removed by accident?

> -	rc = dasd_set_feature(base->cdev, DASD_FEATURE_READONLY, intval);
> +	if (!ro && test_bit(DASD_FLAG_DEVICE_RO, &base->flags))
> +		rc = -EROFS;
> +	else
> +		rc = dasd_set_feature(base->cdev, DASD_FEATURE_READONLY, ro);
>  	dasd_put_device(base);
>  	return rc;
>  }
> @@ -633,9 +627,6 @@ int dasd_ioctl(struct block_device *bdev, fmode_t mode,
>  	case BIODASDPRRST:
>  		rc = dasd_ioctl_reset_profile(block);
>  		break;
> -	case BLKROSET:
> -		rc = dasd_ioctl_set_ro(bdev, argp);
> -		break;
>  	case DASDAPIVER:
>  		rc = dasd_ioctl_api_version(argp);
>  		break;
> -- 
> 2.28.0
> 
