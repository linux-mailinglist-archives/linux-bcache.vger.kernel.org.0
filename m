Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6395A6403C9
	for <lists+linux-bcache@lfdr.de>; Fri,  2 Dec 2022 10:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbiLBJxO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 2 Dec 2022 04:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiLBJxM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 2 Dec 2022 04:53:12 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D3F32BAB
        for <linux-bcache@vger.kernel.org>; Fri,  2 Dec 2022 01:53:10 -0800 (PST)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DF1A021C43;
        Fri,  2 Dec 2022 09:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1669974788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+zRG5JbgWUuxMNXYonKbsJYH50qoprYJ9YwqqiYJdI=;
        b=NVjWKGN4lt+efkUe4LiIVp33aKzLeTgTWf25paWhn905t+q8sIlU0kO2j6VdcO6Byrs09Q
        ENRysrmv3ZiGy8Sc6h7G9aWgGGKs1BPtBVsRFZhWoAiM9zWroyjAUZGAHaY+K/I5sfS7sO
        49RfmZdP2ol6pejiLSnw2xqVobvt6Ms=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1669974788;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+zRG5JbgWUuxMNXYonKbsJYH50qoprYJ9YwqqiYJdI=;
        b=Dj3E4UCZIbUpaRKtdAiJE4O4i0oI2QRO5SIADjirrgYiEAb1gaWmYmxzhqkCupBkAYbWml
        SDNPEhBakJTm5zDQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 4499913644;
        Fri,  2 Dec 2022 09:53:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id qNS6BATLiWNYUgAAGKfGzw
        (envelope-from <colyli@suse.de>); Fri, 02 Dec 2022 09:53:08 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] bcache: don't export tracepoints
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221201063240.402246-1-hch@lst.de>
Date:   Fri, 2 Dec 2022 17:52:57 +0800
Cc:     linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E6C67F90-D2B7-4D43-8289-162A0C627B00@suse.de>
References: <20221201063240.402246-1-hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B412=E6=9C=881=E6=97=A5 14:32=EF=BC=8CChristoph Hellwig =
<hch@lst.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> All bcache tracepoints are only used inside of bcache.ko, so there is
> no point in exporting them.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It is fine to me.

Acked-by: Coly Li <colyli@suse.de <mailto:colyli@suse.de>>


Thanks.

Coly Li


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

