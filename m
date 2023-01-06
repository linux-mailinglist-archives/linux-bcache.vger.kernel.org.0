Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240DA65FE7C
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jan 2023 11:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjAFKBJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Jan 2023 05:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjAFKBI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Jan 2023 05:01:08 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F091C4164C;
        Fri,  6 Jan 2023 02:01:06 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pDjX7-0000wO-Gx; Fri, 06 Jan 2023 11:01:05 +0100
Message-ID: <132043f4-d19a-911d-04c4-a24fdf89153f@leemhuis.info>
Date:   Fri, 6 Jan 2023 11:01:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] bcache: Silence memcpy() run-time false positive warnings
Content-Language: en-US, de-DE
To:     Kees Cook <keescook@chromium.org>, Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20230106060229.never.047-kees@kernel.org>
From:   Thorsten Leemhuis <linux@leemhuis.info>
In-Reply-To: <20230106060229.never.047-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1672999267;823a9b22;
X-HE-SMSGID: 1pDjX7-0000wO-Gx
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 06.01.23 07:02, Kees Cook wrote:
> struct bkey has internal padding in a union, but it isn't always named
> the same (e.g. key ## _pad, key_p, etc). This makes it extremely hard
> for the compiler to reason about the available size of copies done
> against such keys. Use unsafe_memcpy() for now, to silence the many
> run-time false positive warnings:
> 
>   memcpy: detected field-spanning write (size 264) of single field "&i->j" at drivers/md/bcache/journal.c:152 (size 240)
>   memcpy: detected field-spanning write (size 24) of single field "&b->key" at drivers/md/bcache/btree.c:939 (size 16)
>   emcpy: detected field-spanning write (size 24) of single field "&temp.key" at drivers/md/bcache/extents.c:428 (size 16)

Thx for looking into this.

> Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
> Link: https://lore.kernel.org/all/19200730-a3ba-6f4f-bb81-71339bdbbf73@leemhuis.info/

Credit where credit is due, this should be:

Reported-by: Alexandre Pereira <alexpereira@disroot.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216785

> Cc: Coly Li <colyli@suse.de>
> […]

Ciao, Thorsten
