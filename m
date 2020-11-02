Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600712A2B24
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Nov 2020 14:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgKBNCm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Nov 2020 08:02:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44936 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbgKBNCm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Nov 2020 08:02:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2CxMju070463;
        Mon, 2 Nov 2020 13:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=ZbIfwGQlA7ONKWkUUEhlrcz6ZCvbFEQKW2WR4ULQERQ=;
 b=m8+WNO5eVttIMeGiWHlTwCNzv5Bq7FV3K9DsT7vda8oUe5tnW8i3Rpo+OhgEyAFFuYwM
 f/CgAozgHCuSD6EV2dzTyL1aQWt8u1RJd+SRgMKxRPYLld7CwliKtBNDESCisOVOouP7
 aKMFTEl2WSvmQC2zGeyMRR7yAwUWJt0TVZ9WH9x/Hcw+M+Ox7Seg/iLBg+UCAd3UGRlu
 UXSKoO9CTt4BcssrpJ/d0JLJgBvS7ylVkkoxLvEJ2otWc9FW5dBsd6UwE5TyO/so+lo4
 FMGTkr3LAMoFSBMdQZ91y0GzMnwKIWrJqP0b+o8ePKzUdw2CtgwvxWgU2Zdk4AuMKJhN 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34hhvc3nv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 02 Nov 2020 13:02:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2Csjv4169186;
        Mon, 2 Nov 2020 13:02:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34jf46gs7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Nov 2020 13:02:36 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A2D2WWL015239;
        Mon, 2 Nov 2020 13:02:33 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 05:02:32 -0800
Date:   Mon, 2 Nov 2020 16:02:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org
Subject: [bug report] bcache: explicitly make cache_set only have single cache
Message-ID: <20201102130226.GA30570@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=835 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=824
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011020102
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Coly Li,

This is a semi-automatic email about new static checker warnings.

The patch 697e23495c94: "bcache: explicitly make cache_set only have 
single cache" from Oct 1, 2020, leads to the following Smatch 
complaint:

    drivers/md/bcache/super.c:2157 register_cache_set()
    error: we previously assumed 'c->cache' could be null (see line 2125)

drivers/md/bcache/super.c
  2124			if (!memcmp(c->set_uuid, ca->sb.set_uuid, 16)) {
  2125				if (c->cache)
                                    ^^^^^^^^

  2126					return "duplicate cache set member";
  2127	
  2128				goto found;
                                ^^^^^^^^^^
"c->cache" is NULL on this path.

  2129			}
  2130	
  2131		c = bch_cache_set_alloc(&ca->sb);
  2132		if (!c)
  2133			return err;
  2134	
  2135		err = "error creating kobject";
  2136		if (kobject_add(&c->kobj, bcache_kobj, "%pU", c->set_uuid) ||
  2137		    kobject_add(&c->internal, &c->kobj, "internal"))
  2138			goto err;
  2139	
  2140		if (bch_cache_accounting_add_kobjs(&c->accounting, &c->kobj))
  2141			goto err;
  2142	
  2143		bch_debug_init_cache_set(c);
  2144	
  2145		list_add(&c->list, &bch_cache_sets);
  2146	found:
  2147		sprintf(buf, "cache%i", ca->sb.nr_this_dev);
  2148		if (sysfs_create_link(&ca->kobj, &c->kobj, "set") ||
  2149		    sysfs_create_link(&c->kobj, &ca->kobj, buf))
  2150			goto err;
  2151	
  2152		kobject_get(&ca->kobj);
  2153		ca->set = c;
  2154		ca->set->cache = ca;
  2155	
  2156		err = "failed to run cache set";
  2157		if (run_cache_set(c) < 0)
                    ^^^^^^^^^^^^^^^^
c->cache gets dereferenced inside this function without checking when we
do "c->nbuckets = ca->sb.nbuckets;".

  2158			goto err;
  2159	

regards,
dan carpenter
