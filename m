Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 859C3BDE25
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Sep 2019 14:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbfIYMfQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 25 Sep 2019 08:35:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49460 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfIYMfQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 Sep 2019 08:35:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PCY46M123205;
        Wed, 25 Sep 2019 12:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=7ifnu23SX5TLsFQcsvYbwJPydRlnrkRWjN2v3MDuB3Y=;
 b=SIt/77HPnRSaUskBBlE3C48/A7utZNwAwz7uwA0PGN781QjVekLI1zTui/iHtt0JnZVh
 kt+ln1AUjuiTXV9nMkqc/LnVt71BPSIic5yVBaT+D27i1WHtmIxRjlrgYDg0dE2YV5QJ
 tS7mmsyYA8MivPOztjL4jLPBu1qOLOrPz8+geEGH9QaVtduiYm1b5s6IJlD724a6aWmd
 LDGmvY49Qk6Z652TNcv/WsyOqIgPn67L44K7UKZNGsttjn8OGA6Jjc4XLIwx7eIGIoxc
 lilsddXQmh9AeaSwEcUBFbzTiVGSSL7ewYWOjbinMPQRPKX8vm80Nj5JUbCOPswxHhKV nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v5btq4cs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 12:35:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PCXueV093482;
        Wed, 25 Sep 2019 12:35:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v82q9f81k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 12:35:11 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PCWwpm002487;
        Wed, 25 Sep 2019 12:32:58 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 05:32:57 -0700
Date:   Wed, 25 Sep 2019 15:32:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     koverstreet@google.com
Cc:     linux-bcache@vger.kernel.org
Subject: [bug report] bcache: A block layer cache
Message-ID: <20190925123252.GA5926@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=432
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=514 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250128
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Kent Overstreet,

The patch cafe56359144: "bcache: A block layer cache" from Mar 23,
2013, leads to the following static checker warning:

	./drivers/md/bcache/super.c:770 bcache_device_free()
	warn: variable dereferenced before check 'd->disk' (see line 766)

drivers/md/bcache/super.c
   762  static void bcache_device_free(struct bcache_device *d)
   763  {
   764          lockdep_assert_held(&bch_register_lock);
   765  
   766          pr_info("%s stopped", d->disk->disk_name);
                                      ^^^^^^^^^
Unchecked dereference.

   767  
   768          if (d->c)
   769                  bcache_device_detach(d);
   770          if (d->disk && d->disk->flags & GENHD_FL_UP)
                    ^^^^^^^
Check too late.

   771                  del_gendisk(d->disk);
   772          if (d->disk && d->disk->queue)
   773                  blk_cleanup_queue(d->disk->queue);
   774          if (d->disk) {
   775                  ida_simple_remove(&bcache_device_idx,
   776                                    first_minor_to_idx(d->disk->first_minor));
   777                  put_disk(d->disk);
   778          }
   779  

regards,
dan carpenter
