Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 963DB6B481
	for <lists+linux-bcache@lfdr.de>; Wed, 17 Jul 2019 04:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfGQC25 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 16 Jul 2019 22:28:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34824 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfGQC25 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 16 Jul 2019 22:28:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H2O2b4074080;
        Wed, 17 Jul 2019 02:28:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=x0TkQOL90rKxjjC6Of7Ba76QmcmKOQRx6t2pSFqNMjI=;
 b=t6OqAWSHi7kmp+rGZNtsNE7jL3XrH89bgCBfz+fz24gaswR/MG5Dghzhm74zg4TTMF0n
 Y+24tSUaWebG3clzOXCOOngRVOjy0zeyDc67URn2dX9Ho/usZThsJZFRl7UMPuJ5QxND
 rpXBBrsoJKVBQJdOBR16KzFQyq5JpHLGb+q8fjUTSYHgQ3J8djt9+OmpcOyV38lO0X7a
 u/vNvLC5BI+HzPpfEaB4jqrm2uGjK3cGbKgXRo29A9tqVSfGyC1RdQAZ/ncVbfbXM+sz
 2pEIzp6jH65OiGkVisBgfS8u3hS3lzONsCqLEWPFIHFZbzrxxgGtxc/8cEmSeIXivVeB Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2tq6qtqux7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 02:28:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6H2RYQ3106662;
        Wed, 17 Jul 2019 02:28:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tq5bcr1sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 02:28:36 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6H2SYgN021673;
        Wed, 17 Jul 2019 02:28:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Jul 2019 02:28:33 +0000
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-block\@vger.kernel.org" <linux-block@vger.kernel.org>,
        "colyli\@suse.de" <colyli@suse.de>,
        "linux-bcache\@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-btrace\@vger.kernel.org" <linux-btrace@vger.kernel.org>,
        "xen-devel\@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "kent.overstreet\@gmail.com" <kent.overstreet@gmail.com>,
        "yuchao0\@huawei.com" <yuchao0@huawei.com>,
        "jaegeuk\@kernel.org" <jaegeuk@kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "konrad.wilk\@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau\@citrix.com" <roger.pau@citrix.com>,
        "bvanassche\@acm.org" <bvanassche@acm.org>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH V4 1/9] block: add a helper function to read nr_setcs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
        <20190708184711.2984-2-chaitanya.kulkarni@wdc.com>
        <yq18st457yb.fsf@oracle.com>
        <BYAPR04MB5749AF90A9E9C81B4A6857F386F20@BYAPR04MB5749.namprd04.prod.outlook.com>
Date:   Tue, 16 Jul 2019 22:28:30 -0400
In-Reply-To: <BYAPR04MB5749AF90A9E9C81B4A6857F386F20@BYAPR04MB5749.namprd04.prod.outlook.com>
        (Chaitanya Kulkarni's message of "Fri, 12 Jul 2019 16:09:56 +0000")
Message-ID: <yq1sgr5z969.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=930
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907170029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=983 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907170028
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Chaitanya,

> This series just replaces the existing accesses without changing
> anything.
>
> So if any of the exiting code has that bug then it will blow up
> nicely.
>
> For future callers I don't mind adding a new check and resend the
> series.
>
> Would you prefer adding a check ?

I checked your call sites and they look fine. Also, I don't think
returning a capacity of 0 on error is going to help us much.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
