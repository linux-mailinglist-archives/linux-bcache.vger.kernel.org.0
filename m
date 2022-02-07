Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B5C4AB608
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Feb 2022 08:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiBGHnp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Feb 2022 02:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244509AbiBGHh2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Feb 2022 02:37:28 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC00EC043181
        for <linux-bcache@vger.kernel.org>; Sun,  6 Feb 2022 23:37:26 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C44C61F37E;
        Mon,  7 Feb 2022 07:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644219444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oaz+h8graEMxBMh1+3Xq/y1xpVQDN0MahiUQPsZWURQ=;
        b=nslSSl8graSqkSaIdPJVBA0xt9hSd3hHozqq0JqmY4C0r6qHZhU/iSSsM3ykCN9Hehzeh2
        bKl4SJRL54GGrvyjpfz9laHew2g1Y1ujoDC4ySmkpxs1hJzFeDn3/coum5V8UXM7W15FeD
        qs/+ntdZKlFcwkChC4J4u0UzIvDss4U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644219444;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oaz+h8graEMxBMh1+3Xq/y1xpVQDN0MahiUQPsZWURQ=;
        b=d7WYSrbvWtKEShwFCAQ7JfGekzn0kYo3At1VaJOI42O3HgJLxcmAiTdDVrjHZAseTF9+O3
        j2soXQ7YzIaWnWDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8FE1413519;
        Mon,  7 Feb 2022 07:37:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sJTdFjPMAGLRYwAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 07 Feb 2022 07:37:23 +0000
Message-ID: <9f31c511-3898-8ab2-d695-3ae000c7fe99@suse.de>
Date:   Mon, 7 Feb 2022 15:37:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
Content-Language: en-US
From:   Coly Li <colyli@suse.de>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Kai Krakow <kai@kaishome.de>, linux-bcache@vger.kernel.org,
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
In-Reply-To: <c9ebe2b9-d896-4f6e-ecf9-504bd98abe76@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/7/22 2:11 PM, Coly Li wrote:
> On 1/6/22 11:49 PM, Coly Li wrote:
>> On 1/6/22 10:51 AM, Eric Wheeler wrote:
>>
>>>
>>> I'm not sure how to format it 4k, but this is how Frédéric set it to 
>>> 512
>>> bytes and fixed his issue:
>>>
>>> # intelmas start -intelssd 0 -nvmeformat LBAFormat=0
>>> # intelmas start -intelssd 1 -nvmeformat LBAFormat=0
>>
>> Copied. Let me try to find Intel P3700 firstly.
>
> Thanks to Lenovo, they lent me P3700 PCIe SSD for bcache testing and 
> debug. Now I format the card to 4K sector size and see the new 4k 
> sector size from fdisk output.
>
> I start to run fio with 8 io jobs and 256 io depth, 4K random write. 
> Let me see what may happen. If any one has advice to reproduce the 
> non-aligned I/O error more easily, please hint me.

BTW, just for extra clarifying,

The original issue reported by Kai in this thread, is not related to 4Kn 
issue. It is very probably a kernel regression as I replied to his first 
email.

What I am working on, is the problem originally reported by Eric which 
happened on 4Kn devices. I will update the situation on that thread later.

For the problem reported by Kai in this thread, the dmesg

[   27.334306] bcache: bch_cache_set_error() error on
04af889c-4ccb-401b-b525-fb9613a81b69: empty set at bucket 1213, block
1, 0 keys, disabling caching
[   27.334453] bcache: cache_set_free() Cache set
04af889c-4ccb-401b-b525-fb9613a81b69 unregistered
[   27.334510] bcache: register_cache() error sda3: failed to run cache set
[   27.334512] bcache: register_bcache() error : failed to register device

tells that the mate data is corrupted which probably by uncompleted meta data write, which some other people and I countered too (some specific bcache block size on specific device). Update to latest stable kernel may solve the issue, but I don't verify whether the regression is fixed or not.

Coly Li

