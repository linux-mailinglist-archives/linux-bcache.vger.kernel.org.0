Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA8E149FDC
	for <lists+linux-bcache@lfdr.de>; Mon, 27 Jan 2020 09:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgA0I17 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Jan 2020 03:27:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:53570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729058AbgA0I17 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Jan 2020 03:27:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 890DBB18C;
        Mon, 27 Jan 2020 08:27:57 +0000 (UTC)
Subject: Re: [bug report] bcache: avoid unnecessary btree nodes flushing in
 btree_flush_write()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-bcache@vger.kernel.org
References: <20200127061740.kzggwhgxtmmwy34i@kili.mountain>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <aeb36731-1e1c-abb4-d59d-b16aea15dea7@suse.de>
Date:   Mon, 27 Jan 2020 16:27:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200127061740.kzggwhgxtmmwy34i@kili.mountain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/1/27 2:17 下午, Dan Carpenter wrote:
> Hello Coly Li,
> 
> The patch 2aa8c529387c: "bcache: avoid unnecessary btree nodes
> flushing in btree_flush_write()" from Jan 24, 2020, leads to the
> following static checker warning:
> 
> 	drivers/md/bcache/journal.c:444 btree_flush_write()
> 	warn: 'ref_nr' unsigned <= 0
> 

Hi Dan,

Thank you, I will submit the fix in following v5.6-rc version.

BTW, now I use 0-DAY kernel test infrastructure from Intel and my local
gcc -Wall to detect static issue. What is the tool you use to find such
check-minus-value-to-unsigned prlbem ?

Coly Li

> drivers/md/bcache/journal.c
>    422  static void btree_flush_write(struct cache_set *c)
>    423  {
>    424          struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
>    425          unsigned int i, nr, ref_nr;
>                                     ^^^^^^
> 
>    426          atomic_t *fifo_front_p, *now_fifo_front_p;
>    427          size_t mask;
>    428  
>    429          if (c->journal.btree_flushing)
>    430                  return;
>    431  
>    432          spin_lock(&c->journal.flush_write_lock);
>    433          if (c->journal.btree_flushing) {
>    434                  spin_unlock(&c->journal.flush_write_lock);
>    435                  return;
>    436          }
>    437          c->journal.btree_flushing = true;
>    438          spin_unlock(&c->journal.flush_write_lock);
>    439  
>    440          /* get the oldest journal entry and check its refcount */
>    441          spin_lock(&c->journal.lock);
>    442          fifo_front_p = &fifo_front(&c->journal.pin);
>    443          ref_nr = atomic_read(fifo_front_p);
>    444          if (ref_nr <= 0) {
>                     ^^^^^^^^^^^
> Unsigned can't be less than zero.
> 
>    445                  /*
>    446                   * do nothing if no btree node references
>    447                   * the oldest journal entry
>    448                   */
>    449                  spin_unlock(&c->journal.lock);
>    450                  goto out;
>    451          }
>    452          spin_unlock(&c->journal.lock);
> 
> regards,
> dan carpenter
> 
