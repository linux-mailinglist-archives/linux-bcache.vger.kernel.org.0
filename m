Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8C82FBB5
	for <lists+linux-bcache@lfdr.de>; Thu, 30 May 2019 14:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfE3Mu5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 30 May 2019 08:50:57 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42075 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfE3Mu4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 30 May 2019 08:50:56 -0400
Received: by mail-ed1-f67.google.com with SMTP id g24so8951237eds.9
        for <linux-bcache@vger.kernel.org>; Thu, 30 May 2019 05:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=7OvnikCy75K0exOcBmpBGW710HGDLKjNimIt+MTje6k=;
        b=lojG675Qoersd0YKfJBF4Ks+2uGFhd+fHOjSMORs20cgTpKVl+rv3oaLSdWgePLoxl
         QyUKHot9EUM8MEsMhBlypMoNVQFoiSgoXyQGonNkTuuzhAeto/RLv5LWM0//wcz6auXr
         Cy5X8J4og1hUvcdQvzr9Z3Y/DA6gSaeWgKBaecV0DeBykcnM9dRodUA3hMgQPo0Eh9jh
         BoAsbFR1zcmBOkXnAujR53Avr0QnpwH1FzOfsjXNpvsdBJ46xnKa2Sy1wmlY4oLCQLwM
         4CDVvCpcB3V9ZzTbAUREDT5mBO10PIg9XjqUVYSwA2EWhUuNUiG+xvlvSBijCX87rDUW
         gp6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7OvnikCy75K0exOcBmpBGW710HGDLKjNimIt+MTje6k=;
        b=OnRnAhvGpcH/hjtJAdJjW5k+YwPHg789Ih71vtYi7OSAPpwM/bVEc2dzfdaJr4/lkM
         a+7c7BNTG55Ne607ta6Qbv2fUrGd8R/uOI7+q4OLd0SELf09LtQEZ+QgSgvLfw2JwoEN
         ZZAXKqmpHThH3FPcv6jm9FkeX1K7lX3J8fVymG2ZpyrJ60+x5b689mTQ1Li8U462on7N
         O4oIFY4yhxHCjF6Fvw+qPqthCyWv3dMqU7TfmiSEGYEqO1rfPNp75L8k73/hNxvDEN1v
         FNzP9Yo5YhqaoVyndZgyWA/vQYHBYXGkm9rI8N/S7VRJhhgg422TL+QaW4GeYizEKc5l
         i3Bg==
X-Gm-Message-State: APjAAAXrc/BOmZlsHAH6yCEWHBE2HNPPJxV5LmTsoHUcED38w+SUhVRi
        DGJ9lEEQo76U0HR7z2428tXfQw==
X-Google-Smtp-Source: APXvYqzakinNlRR5GUTXv/QUr7J99DWJPj9SyurKhwpQMqRw5L/BVJYk/Ybr0FjI9Yxc82+zH+SMPQ==
X-Received: by 2002:a17:906:2db2:: with SMTP id g18mr3371534eji.79.1559220655450;
        Thu, 30 May 2019 05:50:55 -0700 (PDT)
Received: from home07.rolf-en-monique.lan (94-212-138-219.cable.dynamic.v4.ziggo.nl. [94.212.138.219])
        by smtp.gmail.com with ESMTPSA id v22sm423069eji.13.2019.05.30.05.50.54
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 05:50:54 -0700 (PDT)
Subject: Re: Critical bug on bcache kernel module in Fedora 30
To:     Nix <nix@esperi.org.uk>, Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, kent.overstreet@gmail.com,
        Pierre JUHEN <pierre.juhen@orange.fr>
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
 <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
 <5cdfb1f7-a4b5-0dff-ae86-e5b74515bda9@suse.de>
 <cbd597ad-ed21-34ef-1fec-03fa943fd704@orange.fr>
 <cefbcdf6-6ab6-6ab0-8afa-bcd4d85401a5@suse.de>
 <9fc7c451-0507-b5c3-efc8-ab1baf7a1d44@suse.de> <878suzfk4a.fsf@esperi.org.uk>
From:   Rolf Fokkens <rolf@rolffokkens.nl>
Message-ID: <3340607a-bb62-0bc6-420f-8338283d31d7@rolffokkens.nl>
Date:   Thu, 30 May 2019 14:50:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <878suzfk4a.fsf@esperi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: nl-NL
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Not being sure if people here follow the issue at Fedora I'd like to 
pass a suggestion: https://bugzilla.redhat.com/show_bug.cgi?id=1708315#c27

On 5/22/19 1:44 AM, Nix wrote:
> On 21 May 2019, Coly Li uttered the following:
>> Also I try to analyze the assemble code of bcache, just find out the
>> generated assembly code between gcc9 and gcc7 is quite different. For
>> gcc9 there is a XXXX.cold part. So far I can not tell where the problem
>> is from yet.
> This is hot/cold partitioning. You can turn it off with
> -fno-reorder-blocks-and-partition and see if that helps things (and if
> it doesn't, it should at least make stuff easier to compare).


