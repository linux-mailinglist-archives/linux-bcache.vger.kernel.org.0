Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC7149EF6
	for <lists+linux-bcache@lfdr.de>; Mon, 27 Jan 2020 07:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgA0GRz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Jan 2020 01:17:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38362 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgA0GRy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Jan 2020 01:17:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00R6EF6B134973;
        Mon, 27 Jan 2020 06:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=lAtOAO8NA5/b7bi5RSE7nZQ+t9ZJ5eiqz3b4eNGvN8Q=;
 b=DbFivpDe532mNHWrVA3JZ990ebpuziMpz2V3fv5hLe8QFv83uHgfmyCeNk86jWTTITQB
 ZYJsjsVgamsjr0pddB7DzTBNgMnxrHxckRreKDyA86pwf3Fyx/YG18bS5i8Gt0LX17CF
 vzCi21ydCtiIy2S0kosrf4iJlBeMEvgTJPHW3w4LlQh2wDvoM+jSqkTzX3qOW8vAKJKB
 85LfT4pFuOlaNl8LDSGl5MCR1TicdcUUMyO+qfUS6nkSr9pkkR8ovAnxqiERY6EAc6Dv
 uq8ELHbvs8qjCWiForyrZMXa3cBBcbQsqbxwh9Uo0593OqISD1JnguDGvB4kTxR5Ze2m dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xreaqw7r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jan 2020 06:17:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00R6E6wk154975;
        Mon, 27 Jan 2020 06:17:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xryu8p12n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jan 2020 06:17:49 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00R6HlO1001906;
        Mon, 27 Jan 2020 06:17:47 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 22:17:47 -0800
Date:   Mon, 27 Jan 2020 09:17:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org
Subject: [bug report] bcache: avoid unnecessary btree nodes flushing in
 btree_flush_write()
Message-ID: <20200127061740.kzggwhgxtmmwy34i@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=626
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001270054
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=685 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001270054
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Coly Li,

The patch 2aa8c529387c: "bcache: avoid unnecessary btree nodes
flushing in btree_flush_write()" from Jan 24, 2020, leads to the
following static checker warning:

	drivers/md/bcache/journal.c:444 btree_flush_write()
	warn: 'ref_nr' unsigned <= 0

drivers/md/bcache/journal.c
   422  static void btree_flush_write(struct cache_set *c)
   423  {
   424          struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
   425          unsigned int i, nr, ref_nr;
                                    ^^^^^^

   426          atomic_t *fifo_front_p, *now_fifo_front_p;
   427          size_t mask;
   428  
   429          if (c->journal.btree_flushing)
   430                  return;
   431  
   432          spin_lock(&c->journal.flush_write_lock);
   433          if (c->journal.btree_flushing) {
   434                  spin_unlock(&c->journal.flush_write_lock);
   435                  return;
   436          }
   437          c->journal.btree_flushing = true;
   438          spin_unlock(&c->journal.flush_write_lock);
   439  
   440          /* get the oldest journal entry and check its refcount */
   441          spin_lock(&c->journal.lock);
   442          fifo_front_p = &fifo_front(&c->journal.pin);
   443          ref_nr = atomic_read(fifo_front_p);
   444          if (ref_nr <= 0) {
                    ^^^^^^^^^^^
Unsigned can't be less than zero.

   445                  /*
   446                   * do nothing if no btree node references
   447                   * the oldest journal entry
   448                   */
   449                  spin_unlock(&c->journal.lock);
   450                  goto out;
   451          }
   452          spin_unlock(&c->journal.lock);

regards,
dan carpenter
