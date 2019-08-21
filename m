Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81EAC9732D
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 09:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfHUHQY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 03:16:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48042 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbfHUHQX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 03:16:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7L7Df0x087338;
        Wed, 21 Aug 2019 07:16:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=yoJk5pi/dKjAmxPpNS+NE1o/QG3sQIDGWGQzUSCWyqs=;
 b=k1yIGeAB0ZMGlaZxHMwKJBi8EYnSNWX3q78ePbvCVYyX0CqKID2N4/eoY3OcsJcyB+7E
 bGtnUq1XZlrnrQ5znjirkiTdKSIjVbMm9Lhbyyu8yeTcRVweII9fgbhzKhLE0cv3+4ZI
 E8VEi0m+/dsRNQ/khVTnq5J9+gK56RFe7suMrBZxEyTO6kd5RyzI24aw26rehrRhosdX
 0mttI6u7o4KHeIfObdK9Q5UZuAh77yDCybZFEX8UHcwK+5UnSjvlDgvGt4p7DvkZjmSa
 bH3ThIiWMPFCiGcR56PBNEAzUBFauj5Wfm63E1eP7suhyqLMAKttRrbcAOKRiMH/6vaL 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ue9hpkbuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 07:16:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7L7EIt3066875;
        Wed, 21 Aug 2019 07:16:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ugj7q453c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 07:16:19 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7L7GHDD018509;
        Wed, 21 Aug 2019 07:16:18 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Aug 2019 00:16:17 -0700
Date:   Wed, 21 Aug 2019 10:16:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] bcache: Fix an error code in bch_dump_read()
Message-ID: <20190821071611.GH26957@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908210078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908210078
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The copy_to_user() function returns the number of bytes remaining to be
copied, but the intention here was to return -EFAULT if the copy fails.

Fixes: cafe56359144 ("bcache: A block layer cache")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Another option to fix this bug would be to return the number of bytes
which were successfully copied.  But probably -EFAULT is the right fix.

 drivers/md/bcache/debug.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 8b123be05254..336f43910383 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -178,10 +178,9 @@ static ssize_t bch_dump_read(struct file *file, char __user *buf,
 	while (size) {
 		struct keybuf_key *w;
 		unsigned int bytes = min(i->bytes, size);
-		int err = copy_to_user(buf, i->buf, bytes);
 
-		if (err)
-			return err;
+		if (copy_to_user(buf, i->buf, bytes))
+			return -EFAULT;
 
 		ret	 += bytes;
 		buf	 += bytes;
-- 
2.20.1

