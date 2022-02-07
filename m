Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5621C4AB669
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Feb 2022 09:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241573AbiBGIPJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Feb 2022 03:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239137AbiBGIN5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Feb 2022 03:13:57 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92F3C043184
        for <linux-bcache@vger.kernel.org>; Mon,  7 Feb 2022 00:13:56 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 87F291F37E;
        Mon,  7 Feb 2022 08:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644221635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+rAyDv5A7/myj+EML/u1EHRG2G9fFFYMUnXYQBMmKMY=;
        b=GjknTzRxcLC1FynpCjA2nqrYuFCvfbremTlirE8n7ghvdjO5w7QDQ/tMbD1l4zNv9MCqOS
        uj0+CAfUjRS7YRRrf+kDYFtNh59tUUitBVNLP25fid1vxVJyWZhQMNFw3wArMhRmFbDnSc
        YmC5d9ByYQe3Tf6zsChYuRqhgGvyR6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644221635;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+rAyDv5A7/myj+EML/u1EHRG2G9fFFYMUnXYQBMmKMY=;
        b=oUW9eqhXBC0Ni60uqGgJZ0iTZc1Wog7JGUUdkasOZ8PCUQIBAZcDtBQBlpxjcbdpNtVYU3
        QPqqau775jdr/DAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 175E613B2D;
        Mon,  7 Feb 2022 08:13:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Fgb0McHUAGKBcwAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 07 Feb 2022 08:13:53 +0000
Message-ID: <e7caa84c-6bd1-bc81-caa1-6e7d7c3298a5@suse.de>
Date:   Mon, 7 Feb 2022 16:13:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
Content-Language: en-US
To:     Kai Krakow <kai@kaishome.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org,
        =?UTF-8?Q?Fr=c3=a9d=c3=a9ric_Dumas?= <f.dumas@ellis.siteparc.fr>,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
 <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de>
 <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com>
 <688136f0-78a9-cf1f-cc68-928c4316c81b@bcache.ewheeler.net>
 <8e25f190-c712-0244-3bfd-65f1d7c7df33@suse.de>
 <431f7be3-3b72-110-692c-ca8a11265d3@ewheeler.net>
 <8799ba1c-5c12-d69b-948f-4df9667a801a@suse.de>
 <c9ebe2b9-d896-4f6e-ecf9-504bd98abe76@suse.de>
 <9f31c511-3898-8ab2-d695-3ae000c7fe99@suse.de>
 <CAC2ZOYsHY=7-zJ8WApgC6rhaMyFLp+-=83hD1pdzB2xBrSEfUg@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAC2ZOYsHY=7-zJ8WApgC6rhaMyFLp+-=83hD1pdzB2xBrSEfUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/7/22 4:10 PM, Kai Krakow wrote:
> Am Mo., 7. Feb. 2022 um 08:37 Uhr schrieb Coly Li <colyli@suse.de>:
>
>> For the problem reported by Kai in this thread, the dmesg
>>
>> [   27.334306] bcache: bch_cache_set_error() error on
>> 04af889c-4ccb-401b-b525-fb9613a81b69: empty set at bucket 1213, block
>> 1, 0 keys, disabling caching
>> [   27.334453] bcache: cache_set_free() Cache set
>> 04af889c-4ccb-401b-b525-fb9613a81b69 unregistered
>> [   27.334510] bcache: register_cache() error sda3: failed to run cache set
>> [   27.334512] bcache: register_bcache() error : failed to register device
>>
>> tells that the mate data is corrupted which probably by uncompleted meta data write, which some other people and I countered too (some specific bcache block size on specific device). Update to latest stable kernel may solve the issue, but I don't verify whether the regression is fixed or not.
> As far as I can tell, the problem hasn't happened again since. I think
> I saw the problem in 5.15.2 (the first 5.15.x I tried), and it was
> fixed probably by 'bcache: Revert "bcache: use bvec_virt"' in 5.15.3.
> I even tried write-back mode again on multiple systems and it is
> stable. OTOH, I must say that I only enabled writeback caching after
> using btrfs metadata hinting patches which can move metadata to native
> SSD devices - so bcache will no longer handle btrfs metadata writes or
> reads. Performance-wise, this seems a superior setup, even bcache
> seems to struggle with btrfs metadata access patterns. But I doubt it
> has anything to do with whether the 5.15.2 problem triggers or
> doesn't, just wanted to state that for completeness.

Copied. Thank you for the information. And by your information, I am 
triggered by this report to find hardware to debug another existing 
issue for years. This is a powerful motivation from community :-)


Coly Li
