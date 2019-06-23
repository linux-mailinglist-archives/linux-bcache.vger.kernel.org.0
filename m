Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0064C4F966
	for <lists+linux-bcache@lfdr.de>; Sun, 23 Jun 2019 02:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbfFWAla (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 22 Jun 2019 20:41:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFWAla (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 22 Jun 2019 20:41:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5N0fN4F137368;
        Sun, 23 Jun 2019 00:41:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=J+z+M4DxF8VeiH/SFm0jJi7hUA1gtP2EOoXI6xVLPGQ=;
 b=qGH0WBAr0WvtrXmJgAbrSjGmz2SbYYAoVdsDmn4NlazAoKO0qSGVZB5MzTRwo6eCmNHu
 F8fstYecG/qKVpPM1g0oaBrS1YdpbSBcoc18gwKT80jZcvTS0muKtHBlOfmbsegc9gfk
 /LR4elJD/B4hBs95z1er/5zjJnmICj8lhGXejqTWWS6TmfVoYI2pIU+2LJzIbDoG2Lme
 Kek4rSx/mH29CZZl5zQ9DcQCPDoMxSZAmGYZK6iKNvYzsvAjnXHXt/qZjZ4UV2wo1tFa
 zsyRfX85ohrquFlpUlKzTjx/I6v8F5xTsY8E28Tfo7KqSYvmRG/EyLjDY2TRKeqXW4tG HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t9brssrq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jun 2019 00:41:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5N0fMKI155776;
        Sun, 23 Jun 2019 00:41:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t9acb0fwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jun 2019 00:41:22 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5N0fEuc021875;
        Sun, 23 Jun 2019 00:41:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 22 Jun 2019 17:41:14 -0700
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        Eric Wheeler <git@linux.ewheeler.net>,
        Eric Wheeler <bcache@linux.ewheeler.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        linux-bcache@vger.kernel.org (open list:BCACHE (BLOCK LAYER CACHE))
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent for hardware raid5/6
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
        <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
Date:   Sat, 22 Jun 2019 20:41:11 -0400
In-Reply-To: <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
        (Eric Wheeler's message of "Sat, 22 Jun 2019 16:16:09 -0700")
Message-ID: <yq1v9wxnnfc.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9296 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=586
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906230004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9296 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=641 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906230004
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Eric,

> While some drivers set queue_limits.io_opt (e.g., md raid5), there are
> currently no SCSI/RAID controller drivers that do.

That's not true. Lots of SCSI RAID devices report a stripe width.

-- 
Martin K. Petersen	Oracle Linux Engineering
