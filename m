Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22CD757F4F
	for <lists+linux-bcache@lfdr.de>; Thu, 27 Jun 2019 11:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfF0J0A (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 27 Jun 2019 05:26:00 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:2112 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfF0J0A (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Jun 2019 05:26:00 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jun 2019 05:25:53 EDT
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app12-12012 (RichMail) with SMTP id 2eec5d148953baf-36dbd; Thu, 27 Jun 2019 17:16:03 +0800 (CST)
X-RM-TRANSID: 2eec5d148953baf-36dbd
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[112.25.65.41])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee55d14895293b-651fd;
        Thu, 27 Jun 2019 17:16:03 +0800 (CST)
X-RM-TRANSID: 2ee55d14895293b-651fd
Date:   Thu, 27 Jun 2019 17:16:12 +0800
From:   Yaowei Bai <baiyaowei@cmss.chinamobile.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 06/29] bcache: fix race in btree_flush_write()
Message-ID: <20190627091611.GA15287@byw>
Reply-To: baiyaowei@cmss.chinamobile.com
References: <20190614131358.2771-1-colyli@suse.de>
 <20190614131358.2771-7-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614131358.2771-7-colyli@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Jun 14, 2019 at 09:13:35PM +0800, Coly Li wrote:
> There is a race between mca_reap(), btree_node_free() and journal code
> btree_flush_write(), which results very rare and strange deadlock or
> panic and are very hard to reproduce.
> 
> Let me explain how the race happens. In btree_flush_write() one btree
> node with oldest journal pin is selected, then it is flushed to cache
> device, the select-and-flush is a two steps operation. Between these two
> steps, there are something may happen inside the race window,
> - The selected btree node was reaped by mca_reap() and allocated to
>   other requesters for other btree node.
> - The slected btree node was selected, flushed and released by mca
>   shrink callback bch_mca_scan().
> When btree_flush_write() tries to flush the selected btree node, firstly
> b->write_lock is held by mutex_lock(). If the race happens and the
> memory of selected btree node is allocated to other btree node, if that
> btree node's write_lock is held already, a deadlock very probably
> happens here. A worse case is the memory of the selected btree node is
> released, then all references to this btree node (e.g. b->write_lock)
> will trigger NULL pointer deference panic.
> 
> This race was introduced in commit cafe56359144 ("bcache: A block layer
> cache"), and enlarged by commit c4dc2497d50d ("bcache: fix high CPU
> occupancy during journal"), which selected 128 btree nodes and flushed
> them one-by-one in a quite long time period.
> 
> Such race is not easy to reproduce before. On a Lenovo SR650 server with
> 48 Xeon cores, and configure 1 NVMe SSD as cache device, a MD raid0
> device assembled by 3 NVMe SSDs as backing device, this race can be
> observed around every 10,000 times btree_flush_write() gets called. Both
> deadlock and kernel panic all happened as aftermath of the race.
> 
> The idea of the fix is to add a btree flag BTREE_NODE_journal_flush. It
> is set when selecting btree nodes, and cleared after btree nodes
> flushed. Then when mca_reap() selects a btree node with this bit set,
> this btree node will be skipped. Since mca_reap() only reaps btree node
> without BTREE_NODE_journal_flush flag, such race is avoided.
> 
> Once corner case should be noticed, that is btree_node_free(). It might
> be called in some error handling code path. For example the following
> code piece from btree_split(),
> 	2149 err_free2:
> 	2150         bkey_put(b->c, &n2->key);
> 	2151         btree_node_free(n2);
> 	2152         rw_unlock(true, n2);
> 	2153 err_free1:
> 	2154         bkey_put(b->c, &n1->key);
> 	2155         btree_node_free(n1);
> 	2156         rw_unlock(true, n1);
> At line 2151 and 2155, the btree node n2 and n1 are released without
> mac_reap(), so BTREE_NODE_journal_flush also needs to be checked here.
> If btree_node_free() is called directly in such error handling path,
> and the selected btree node has BTREE_NODE_journal_flush bit set, just
> wait for 1 jiffy and retry again. In this case this btree node won't
> be skipped, just retry until the BTREE_NODE_journal_flush bit cleared,
> and free the btree node memory.
> 
> Wait for 1 jiffy inside btree_node_free() does not hurt too much
> performance here, the reasons are,
> - Error handling code path is not frequently executed, and the race
>   inside this cold path should be very rare. If the very rare race
>   happens in the cold code path, waiting 1 jiffy should be acceptible.
> - If bree_node_free() is called inside mca_reap(), it means the bit
>   BTREE_NODE_journal_flush is checked already, no wait will happen here.
> 
> Beside the above fix, the way to select flushing btree nodes is also
> changed in this patch. Let me explain what changes in this patch.

Then this change should be split into another patch. :)

> 


