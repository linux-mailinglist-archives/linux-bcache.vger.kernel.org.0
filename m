Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE30463E9FD
	for <lists+linux-bcache@lfdr.de>; Thu,  1 Dec 2022 07:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiLAGvU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 1 Dec 2022 01:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiLAGvU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Dec 2022 01:51:20 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9E077401
        for <linux-bcache@vger.kernel.org>; Wed, 30 Nov 2022 22:51:19 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CABB421B11;
        Thu,  1 Dec 2022 06:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1669877477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrLqNbVkQ81IwOq0HaAadFkSQyOgnNRdD8XBTY1NtaY=;
        b=DRpYkVa6ooC0vvtxGO7nIRg9IaQEAA0xgABrLTUhQUuX6tLlIVlh4XGAj5heh3/bZ2uQxc
        qdcn8TdcXYPzMiMl5VdKKq4HJVaZHodjhrl0B38CP1rDyhUNEjBAU26TWD676UsBxYUZOO
        AGwX634SWyHC/R1a6cLh5GroNfUOqjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1669877477;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrLqNbVkQ81IwOq0HaAadFkSQyOgnNRdD8XBTY1NtaY=;
        b=/WPBspp5qcI4msarJ9SyC26coGsCUWsLK03cpmEgcVwRI9r63nJrY14uOMp8xBFlXxvzo5
        0g6AwJmxIn/sjcDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EB3E013A32;
        Thu,  1 Dec 2022 06:51:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xTPdLOROiGO1LwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 01 Dec 2022 06:51:16 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] bcache: don't export tracepoints
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221201063240.402246-1-hch@lst.de>
Date:   Thu, 1 Dec 2022 14:51:03 +0800
Cc:     linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <123515F8-F583-425E-BCBE-AA509690EC42@suse.de>
References: <20221201063240.402246-1-hch@lst.de>
To:     Kent Overstreet <kent.overstreet@gmail.com>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Kent,

Could you please response this change? It seems to be fine to make these =
tracepoints static inside bcache, but I am not 100% for your original =
idea.

Thank you in advance.

Coly Li

> 2022=E5=B9=B412=E6=9C=881=E6=97=A5 14:32=EF=BC=8CChristoph Hellwig =
<hch@lst.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> All bcache tracepoints are only used inside of bcache.ko, so there is
> no point in exporting them.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> drivers/md/bcache/trace.c | 44 ---------------------------------------
> 1 file changed, 44 deletions(-)
>=20
> diff --git a/drivers/md/bcache/trace.c b/drivers/md/bcache/trace.c
> index a9a73f560c0442..600efecf9bd9de 100644
> --- a/drivers/md/bcache/trace.c
> +++ b/drivers/md/bcache/trace.c
> @@ -7,47 +7,3 @@
>=20
> #define CREATE_TRACE_POINTS
> #include <trace/events/bcache.h>
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_request_start);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_request_end);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_bypass_sequential);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_bypass_congested);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_read);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_write);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_read_retry);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_cache_insert);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_journal_replay_key);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_journal_write);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_journal_full);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_journal_entry_full);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_cache_cannibalize);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_read);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_write);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_node_alloc);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_node_alloc_fail);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_node_free);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_gc_coalesce);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_gc_start);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_gc_end);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_gc_copy);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_gc_copy_collision);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_insert_key);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_node_split);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_node_compact);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_btree_set_root);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_invalidate);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_alloc_fail);
> -
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_writeback);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(bcache_writeback_collision);
> --=20
> 2.30.2
>=20

