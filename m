Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F92151F1A
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Jun 2019 01:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfFXXZC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Jun 2019 19:25:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42158 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfFXXZB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Jun 2019 19:25:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5ONJB6c147243;
        Mon, 24 Jun 2019 23:24:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=aTZd3V8YKxC9aVHKIjLqupfycJYEaoqqnVsM2irnK+k=;
 b=2DbmdT8817TsXxhodPMLfTrvd92O0rNIIIESCqWO+JWnGoSLMSp1lGpHLe8j4HYqEBHt
 UoErpCJKAltSbnB9HLyrF8MsZ4RF4lovMvm8pcshAaoJrIbGIyic3c7W2rcUN90+SAyq
 gq2gtPcFK4rB79is4KWZCSSb5LOICXZXzVFDiCLHFYCkfb11Q4Q72FYfC4BrXFri3Yfe
 DYgqoMvLZEHKc1+m4cJAKLGAUBeP4CRRHejw/+b5tnaaMd3P9g/avAf+569vgv9OhCkq
 ApvuizHTO+jv1uN1FkkUpL/W4jjI1o//KcFkB04yRnBOvRXWnCzRSUx78N1ht5ovzn6R hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t9c9pgy89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 23:24:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5ONNS9m134943;
        Mon, 24 Jun 2019 23:24:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tat7bwgg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 23:24:54 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5ONOnLt013227;
        Mon, 24 Jun 2019 23:24:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 16:24:49 -0700
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list\:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list\:BCACHE \(BLOCK LAYER CACHE\)" 
        <linux-bcache@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent for hardware raid5/6
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
        <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
        <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>
        <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
Date:   Mon, 24 Jun 2019 19:24:44 -0400
In-Reply-To: <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net> (Eric
        Wheeler's message of "Mon, 24 Jun 2019 18:14:59 +0000 (UTC)")
Message-ID: <yq17e9ao9c3.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240184
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Eric,

> Perhaps they do not set stripe_width using io_opt? I did a grep to see
> if any of them did, but I didn't see them. How is stripe_width
> indicated by RAID controllers?

The values are reported in the Block Limits VPD page for each SCSI block
device and are thus set by the SCSI disk driver. IOW, the RAID
controller device drivers have nothing to do with this.

For RAID controllers specifically, the controller firmware will fill out
the VPD fields for each virtual SCSI disk when you configure a RAID
set. For pretty much everything else, the Block Limits come straight
from the device itself.

Also note that these values aren't specific to RAID controllers at
all. Most new SCSI devices, including disk drives and SSDs, will fill
out the Block Limits VPD page one way or the other. Even some USB
storage devices are providing this page.

> If they do set io_opt, then at least my Areca 1883 does not set io_opt
> as of 4.19.x. I also have a LSI MegaRAID 3108 which does not report
> io_opt as of 4.1.x, but that is an older kernel so maybe support has
> been added since then.

I have several MegaRAIDs that all report it. But it depends on the
controller firmware.

> Is it visible through sysfs or debugfs so I can check my hardware
> support without hacking debugging the kernel?

To print the block device topology:

  # lsblk -t

or look up io_opt in sysfs:

  # grep . /sys/block/sdX/queue/optimal_io_size

You can also query a SCSI device's Block Limits directly:

  # sg_vpd -p bl /dev/sdX

If you want to tinker, you can simulate a SCSI disk with your choice of
io_opt:

  # modprobe scsi_debug opt_blks=N

where N is the number of logical blocks to report as being the optimal
I/O size.

-- 
Martin K. Petersen	Oracle Linux Engineering
