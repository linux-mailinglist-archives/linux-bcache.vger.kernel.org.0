Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104C72AF6F5
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Nov 2020 17:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbgKKQxj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Nov 2020 11:53:39 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55940 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgKKQxi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Nov 2020 11:53:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ABGjcP7055598;
        Wed, 11 Nov 2020 16:53:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=rtr9ZwfifFQUB6Xm7rE6zrQB75duW4A6ZUujJWOIcy0=;
 b=exGX3C0qT4hc/xlWa/AIm9ktJgo3Z//a0o4mVgKdeKGmGA/eaFYoQbi800neiStHpB4e
 tFsrnOWmxAuossvNG8Pw+BxUWop8xMBSCqnr7z/BRW8uJVoZbgurNkL3ZGrwGHzwfuA4
 Gs7RSMJIhJKB1v4bnboh+uSU+6W4DiMcXMh1h5xVZ0dpa9hpH3Rl5ykPpFR0of3rZSoX
 +jIlTtURtYo1Dq5KH+0vEOfFvvvdWfCnug14v78NOiYUPi1u0vBpnSjlcACdYBGweMr2
 1yEDh9l2TA2MZkJqrSGrANe41/rwZrW/lu4+bGwkBt467AYodHuM5qVxksGh9ZXr0qZt /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72er0e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 16:53:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ABGitBl102834;
        Wed, 11 Nov 2020 16:53:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34p5g1x6bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 16:53:11 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ABGr6tR015124;
        Wed, 11 Nov 2020 16:53:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Nov 2020 08:53:05 -0800
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Ilya Dryomov <idryomov@gmail.com>, Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH, RFC 11/10] block: propagate BLKROSET to all partitions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8k3dei6.fsf@ca-mkp.ca.oracle.com>
References: <20201106140817.GA23557@lst.de>
        <yq1imacecwz.fsf@ca-mkp.ca.oracle.com> <20201111080334.GA23062@lst.de>
Date:   Wed, 11 Nov 2020 11:53:02 -0500
In-Reply-To: <20201111080334.GA23062@lst.de> (Christoph Hellwig's message of
        "Wed, 11 Nov 2020 09:03:34 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9802 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110099
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Christoph,

> I actually think your patch that goes further is the right thing to
> do, and I was going to look into something similar for a problem with
> hardware read-only namespaces in NVMe.  I think I'll take your patch
> as a starting point and will work from there.

Sounds good!

I still have the blktests in a branch. Will adjust and resubmit once you
post your rework.

-- 
Martin K. Petersen	Oracle Linux Engineering
