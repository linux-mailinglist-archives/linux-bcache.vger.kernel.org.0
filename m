Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BF148672A
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jan 2022 16:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240758AbiAFPzm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jan 2022 10:55:42 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47536 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240812AbiAFPzl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jan 2022 10:55:41 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3DF4A1F397;
        Thu,  6 Jan 2022 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641484540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gnpY1RlKoSMaRld3GV7tWxzHhQSenL5FVxArO7tfTJI=;
        b=kNHFcTU7hR4cTyBo8smDgh/DLUEHQoSDe6dfILvwd+qO8G0WBKPreoyY7uDZ64akCnCJPC
        w6fdEbvChgQktqLzgWxPTBIuQAKOlhrkXR3NoCImAuVNmm27jet/TEZ2DaB85ijdf7RJLD
        ZfJsnNx7K4noMVRHGwsFm00EooF9c3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641484540;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gnpY1RlKoSMaRld3GV7tWxzHhQSenL5FVxArO7tfTJI=;
        b=c5b4DFzkSn11wDp1V0aTm+RgTchZ7RhEP+UU0yCAqpXhA+F7OY3mLV+S2oR0drNilFLOTK
        ClZvPWGH5COUNIBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1ADCD13C5D;
        Thu,  6 Jan 2022 15:55:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Cb4UOPoQ12G4AQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 06 Jan 2022 15:55:38 +0000
Message-ID: <0eb291b1-86af-94ed-b765-9b632050ed9f@suse.de>
Date:   Thu, 6 Jan 2022 23:55:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
Content-Language: en-US
To:     =?UTF-8?Q?Fr=c3=a9d=c3=a9ric_Dumas?= <f.dumas@ellis.siteparc.fr>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Kai Krakow <kai@kaishome.de>, linux-bcache@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
 <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de>
 <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com>
 <688136f0-78a9-cf1f-cc68-928c4316c81b@bcache.ewheeler.net>
 <8e25f190-c712-0244-3bfd-65f1d7c7df33@suse.de>
 <431f7be3-3b72-110-692c-ca8a11265d3@ewheeler.net>
 <7212111D-5181-458B-B774-006D3B08A9AE@ellis.siteparc.fr>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <7212111D-5181-458B-B774-006D3B08A9AE@ellis.siteparc.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/6/22 5:25 PM, Frédéric Dumas wrote:
> Hello!
>
> Many thanks to Eric for describing here and in his previous email the bug I experienced using bcache on SSDs formatted as 4k sectors. Thanks also to him for explaining to me that all I had to do was reformat the SSDs into 512-byte sectors to easily get around the bug.
>
>
>> I'm not sure how to format it 4k, but this is how Frédéric set it to 512
>> bytes and fixed his issue:
>>
>> # intelmas start -intelssd 0 -nvmeformat LBAFormat=0
>
> Right.
> To format an Intel NVMe P3700 back to 4k sectors, the command is as follows:
>
> # intelmas start -intelssd 0 -nvmeformat LBAFormat=3
>
>
>> The parameter LBAformat specifies the sector size to set. Valid options are in the range from index 0 to the number of supported LBA formats of the NVMe drive, however the only sector sizes supported in Intel® NVMe drives are 512B and 4096B which corresponds to indexes 0 and 3 respectively.
>
> Source: https://www.intel.com/content/www/us/en/support/articles/000057964/memory-and-storage.html
>
> Oddly enough the user manual for the intelmass application [1] (formerly isdct) forgets to specify the possible values to be given to the LBAformat argument, which makes it much less useful. :-)

Hi Frederic,

Many thanks for the information. BTW, could you please tell me the 
detail information about your Intel NVMe P3700 SSD, I will try to find 
it in local market.

Coly Li
