Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD32A2D68
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Nov 2020 15:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgKBOxu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Nov 2020 09:53:50 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38994 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgKBOxu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Nov 2020 09:53:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2EjUEI113225;
        Mon, 2 Nov 2020 14:53:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=V3pUHC5uBrUP8dSwsk1nrrsCwRtUWusvXz6NH1Xhjtk=;
 b=Kxy+wo7RXNjf5sZz/R3j6FGwdp/SWjL3ReYUB7z7WXpqkW+PylrUlgYf48WFqh0tCwL/
 rn+CgK8UMaT30e30wzz+O9BJAfFCO8L9sniJVT0+kLtfm60esEvL659XJ/QxMJ9Po5sh
 9SwdooZmF9/2ila+n88eZuZ+arAzAbhECmEMtc85ylCju5+DxH5dVULjGLWFt7c59p7k
 Nt8680P7pmVZMwpznaMgoVvC2SMPR1HruJlg2K4d6g3GahqRbFAPBG67O/oDjmuCMt58
 5jASrM0x3Fv4SGO55Ddwd6qcnDKWRc3dyFNPBp+AqyYpjB1s4kJOR0wUoqo+SujhbTa/ YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34hhb1vac9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 02 Nov 2020 14:53:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2EojB2148517;
        Mon, 2 Nov 2020 14:53:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34jf46mj2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Nov 2020 14:53:21 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A2ErKaf007445;
        Mon, 2 Nov 2020 14:53:20 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 06:53:20 -0800
Date:   Mon, 2 Nov 2020 17:53:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: [bug report] bcache: explicitly make cache_set only have single
 cache
Message-ID: <20201102145314.GX18329@kadam>
References: <20201102130226.GA30570@mwanda>
 <875c4534-2548-14c4-b6c4-26b6720c8e67@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875c4534-2548-14c4-b6c4-26b6720c8e67@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020118
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Nov 02, 2020 at 10:31:27PM +0800, Coly Li wrote:
> On 2020/11/2 21:02, Dan Carpenter wrote:
> > Hello Coly Li,
> > 
> > This is a semi-automatic email about new static checker warnings.
> > 
> > The patch 697e23495c94: "bcache: explicitly make cache_set only have 
> > single cache" from Oct 1, 2020, leads to the following Smatch 
> > complaint:
> > 
> >     drivers/md/bcache/super.c:2157 register_cache_set()
> >     error: we previously assumed 'c->cache' could be null (see line 2125)
> > 
> > drivers/md/bcache/super.c
> >   2124			if (!memcmp(c->set_uuid, ca->sb.set_uuid, 16)) {
> >   2125				if (c->cache)
> >                                     ^^^^^^^^
> > 
> >   2126					return "duplicate cache set member";
> >   2127	
> >   2128				goto found;
> >                                 ^^^^^^^^^^
> > "c->cache" is NULL on this path.
> > 
> >   2129			}
> >   2130	
> >   2131		c = bch_cache_set_alloc(&ca->sb);
> >   2132		if (!c)
> >   2133			return err;
> >   2134	
> >   2135		err = "error creating kobject";
> >   2136		if (kobject_add(&c->kobj, bcache_kobj, "%pU", c->set_uuid) ||
> >   2137		    kobject_add(&c->internal, &c->kobj, "internal"))
> >   2138			goto err;
> >   2139	
> >   2140		if (bch_cache_accounting_add_kobjs(&c->accounting, &c->kobj))
> >   2141			goto err;
> >   2142	
> >   2143		bch_debug_init_cache_set(c);
> >   2144	
> >   2145		list_add(&c->list, &bch_cache_sets);
> >   2146	found:
> >   2147		sprintf(buf, "cache%i", ca->sb.nr_this_dev);
> >   2148		if (sysfs_create_link(&ca->kobj, &c->kobj, "set") ||
> >   2149		    sysfs_create_link(&c->kobj, &ca->kobj, buf))
> >   2150			goto err;
> >   2151	
> >   2152		kobject_get(&ca->kobj);
> >   2153		ca->set = c;
> >   2154		ca->set->cache = ca;
> >   2155	
> >   2156		err = "failed to run cache set";
> >   2157		if (run_cache_set(c) < 0)
> >                     ^^^^^^^^^^^^^^^^
> > c->cache gets dereferenced inside this function without checking when we
> > do "c->nbuckets = ca->sb.nbuckets;".
> > 
> >   2158			goto err;
> >   2159	
> 
> 
> Hi Dan,
> 
> Hmm, let me check. It seems the trick is at line 2153 and 2154,
> 
> 2153		ca->set = c;
> 2154		ca->set->cache = ca;
> 
> "ca->set->cache = ca" equals to "c->cache = ca", so c->cache is
> initialized and safe. Yes we can write line 2154 as "c->cache = ca", but
> my motivation was little, event for readability.

Argh....  Of course.  Sorry, for the noise.  I feel like this must be a
regression in Smatch which is why it didn't generate a warning earlier.
I'll look into it.

regards,
dan carpenter

