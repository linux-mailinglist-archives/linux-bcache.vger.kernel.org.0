Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881FF3A14B
	for <lists+linux-bcache@lfdr.de>; Sat,  8 Jun 2019 20:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfFHSud (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 8 Jun 2019 14:50:33 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41073 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbfFHSud (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 8 Jun 2019 14:50:33 -0400
Received: by mail-ed1-f67.google.com with SMTP id p15so7400324eds.8
        for <linux-bcache@vger.kernel.org>; Sat, 08 Jun 2019 11:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VYIdX4XgO6EaT4rJ8nz7zqGS+cZzVHpS+M7f3b3s3pw=;
        b=t5nGmBV/2zLK1VX8m0zHE1ywxTT18Kn8QsljCzKR0vBuNtpd7Iz8a80vobB/dL3ES/
         mwQwYG3DFKInn0eBoeO77GPU30a2mMJh9Dj2/YfahsnqX7ftQkIIfI480CQ21WVi1JxD
         clg5yK5FDwun9CieKB9nRUxDemfN6goJWhxJ6VbPUCMon/EKw2n7m4Y5kAVaJ3EPPwX8
         i+RjC6Sc9NbjtLQrYVV3eEvRIWKMTKUihKkl1YMOjwxrd4GeD6ly2UgGbQkeyb6yUBuH
         HL9nPw8P8utJUGTqb8BF6lpHpvRjRR6subMK/Su5GUvLixT+EpTjrGOC4yXSDPDjRlw1
         9eoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VYIdX4XgO6EaT4rJ8nz7zqGS+cZzVHpS+M7f3b3s3pw=;
        b=EWsa6z5EA9kXxz1tpvSL/fgRIimVZTVm2zno+WuBqgYIceOwl1++SRXaagNKOGZPuD
         um4XxvyNH9J+U6VKeKP93QRsXulVd5R7VzhCb3xF/Bbr96SuQkxifd5yAqL3OMhAv/bH
         J4BbNXITDy/YCzuSRosouIydcZa4Behf51HaVW3mndCKbOJq9NZ6i34KhuEEmSvZOgmG
         TrdolGNehwc2mx4tKRaNfu4ACFmpsMdet0L991RYs+ib5bMxS9aRDchTGBAC/3syk713
         MG3OBwNQz9Eiabb16gNL73KwUcNiD0wjNlhFFWO9I13zcc2pN8e8dr9KzmoRtQVSgJZG
         qhLQ==
X-Gm-Message-State: APjAAAVENhVW9RjA2odarOvsmfsN1Xs8K/8GauCBxEaJyAzCM2XRH5BM
        3mV1ZdiiB6f+PBrrguTPzQdxMQ==
X-Google-Smtp-Source: APXvYqzbujPKB55PsCo/LcRg1QzR3MSPREWZ9btkeuodIT/IRjadw0Yh2ch7SpnQCF5b8zBDL/8BZw==
X-Received: by 2002:a17:906:3551:: with SMTP id s17mr51926587eja.19.1560019831806;
        Sat, 08 Jun 2019 11:50:31 -0700 (PDT)
Received: from home07.rolf-en-monique.lan (94-212-138-219.cable.dynamic.v4.ziggo.nl. [94.212.138.219])
        by smtp.gmail.com with ESMTPSA id o7sm1009706ejj.88.2019.06.08.11.50.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 11:50:31 -0700 (PDT)
Subject: Re: [RFC PATCH] bcache: fix stack corruption by PRECEDING_KEY()
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Nix <nix@esperi.org.uk>, Pierre JUHEN <pierre.juhen@orange.fr>,
        linux-block@vger.kernel.org
References: <20190608102204.60126-1-colyli@suse.de>
From:   Rolf Fokkens <rolf@rolffokkens.nl>
Message-ID: <8855017f-729e-9719-236d-e98710702564@rolffokkens.nl>
Date:   Sat, 8 Jun 2019 20:50:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190608102204.60126-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: nl-NL
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/8/19 12:22 PM, Coly Li wrote:
> +static inline void preceding_key(struct bkey *k, struct bkey *preceding_key_p)
> +{
> +	if (KEY_INODE(k) || KEY_OFFSET(k)) {
> +		*preceding_key_p = KEY(KEY_INODE(k), KEY_OFFSET(k), 0);
> +		if (!preceding_key_p->low)
> +			preceding_key_p->high--;
> +		preceding_key_p->low--;
> +	} else {
> +		preceding_key_p = NULL;

If I'm correct, the line above has no net effect, it just changes a 
local variable (parameter) with no effect elsewhere. So the else part 
may be left out, or do you mean this?

*preceding_key_p = ZERO_KEY;

> +	}
> +}
>   
>   static inline bool bch_ptr_invalid(struct btree_keys *b, const struct bkey *k)
>   {


