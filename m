Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BEBF8B1
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Apr 2019 14:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbfD3MVl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Apr 2019 08:21:41 -0400
Received: from smtp-out-02.aalto.fi ([130.233.228.121]:65243 "EHLO
        smtp-out-02.aalto.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfD3MVk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Apr 2019 08:21:40 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2019 08:21:39 EDT
Received: from smtp-out-02.aalto.fi (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id CBA5227130D_CC83B28B;
        Tue, 30 Apr 2019 12:10:16 +0000 (GMT)
Received: from mail.lan (kurp.hut.fi [130.233.36.234])
        by smtp-out-02.aalto.fi (Sophos Email Appliance) with ESMTP id 81F3E271309_CC83B28F;
        Tue, 30 Apr 2019 12:10:16 +0000 (GMT)
Received: from orbit.lan (orbit.lan [IPv6:2001:708:190:7::2:100])
        by mail.lan (Postfix) with ESMTP id 600A71000C9;
        Tue, 30 Apr 2019 15:15:56 +0300 (EEST)
Received: from jha (helo=localhost)
        by orbit.lan with local-esmtp (Exim 4.90_1)
        (envelope-from <juha.aatrokoski@aalto.fi>)
        id 1hLRfw-0007tD-Ai; Tue, 30 Apr 2019 15:15:56 +0300
Date:   Tue, 30 Apr 2019 15:15:56 +0300 (EEST)
From:   Juha Aatrokoski <juha.aatrokoski@aalto.fi>
To:     Coly Li <colyli@suse.de>
cc:     linux-bcache@vger.kernel.org, Shenghui Wang <shhuiw@foxmail.com>
Subject: Re: [PATCH 18/18] bcache: avoid potential memleak of list of
 journal_replay(s) in the CACHE_SYNC branch of run_cache_set
In-Reply-To: <20190424164843.29535-19-colyli@suse.de>
Message-ID: <alpine.DEB.2.21.1904301510350.7886@orbit.lan>
References: <20190424164843.29535-1-colyli@suse.de> <20190424164843.29535-19-colyli@suse.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aalto.fi; h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=its18; bh=XFM+TzimEGmAditcqDhactWBtJtiAPpdUmGnrjMOv2E=; b=kLOOc7Rld0xWVyyccPOqfFk6VztidW2dP7nnmM5mxOWx83agb0mPAigR1X3Y6uTgI5XPNB+Ksft74pySN7zGZwiwRgB9DSF+D5ek/KDB4R8kByjhacGdDvOS6AQN5D5PcFnjIZYirwof1H1UbXOHuk1pJMEeGhgb+Vcoq0pjlmHTKg3utGnLAEoBINvq+m+9aS9Iixs9ree7gtReV6dZCZHYVS8F3SmF0m8kctWleuDXdQlwnd2i1psb9+8R36au7B/O0t3PtSgnC1D2C81RbvcIdkh8/qtJLVjYciBgTPAu2s8z6zjA9vaijU7hRmi8ga6lKAING5g4ECRPqvIHvQ==
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch is missing the following chunk from the original patch:

@@ -1790,7 +1792,6 @@ static void run_cache_set(struct cache_set *c)
         set_gc_sectors(c);

         if (CACHE_SYNC(&c->sb)) {
-               LIST_HEAD(journal);
                 struct bkey *k;
                 struct jset *j;

Unless I'm missing something, without this chunk this patch doesn't do 
anything, as the "journal" that is allocated is the inner one, while the 
"journal" that is freed is the outer one.


On Thu, 25 Apr 2019, Coly Li wrote:

> From: Shenghui Wang <shhuiw@foxmail.com>
>
> In the CACHE_SYNC branch of run_cache_set(), LIST_HEAD(journal) is used
> to collect journal_replay(s) and filled by bch_journal_read().
>
> If all goes well, bch_journal_replay() will release the list of
> jounal_replay(s) at the end of the branch.
>
> If something goes wrong, code flow will jump to the label "err:" and leave
> the list unreleased.
>
> This patch will release the list of journal_replay(s) in the case of
> error detected.
>
> v1 -> v2:
> * Move the release code to the location after label 'err:' to
>  simply the change.
>
> Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
> drivers/md/bcache/super.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 3f34b96ebbc3..0ffe9acee9d8 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1790,6 +1790,8 @@ static int run_cache_set(struct cache_set *c)
> 	struct cache *ca;
> 	struct closure cl;
> 	unsigned int i;
> +	LIST_HEAD(journal);
> +	struct journal_replay *l;
>
> 	closure_init_stack(&cl);
>
> @@ -1949,6 +1951,12 @@ static int run_cache_set(struct cache_set *c)
> 	set_bit(CACHE_SET_RUNNING, &c->flags);
> 	return 0;
> err:
> +	while (!list_empty(&journal)) {
> +		l = list_first_entry(&journal, struct journal_replay, list);
> +		list_del(&l->list);
> +		kfree(l);
> +	}
> +
> 	closure_sync(&cl);
> 	/* XXX: test this, it's broken */
> 	bch_cache_set_error(c, "%s", err);
>
